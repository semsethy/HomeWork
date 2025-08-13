//
//  HWNetworkManager.swift
//  HomeWork
//
//  Created by JoshipTy on 3/8/25.
//

import Foundation
import Combine
import SwiftUI

// MARK: - HTTP Method Enum HTTP
enum HWHttpMethod: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - Network Manager
class HWNetworkManager: NSObject, URLSessionDelegate {
    
    /// Shared instance of the network manager
    static let shared = HWNetworkManager()
    
    private override init() { }
    
    /// Set of cancellables for Combine
    private var cancellables = Set<AnyCancellable>()
    
    /// Add a cancellable to the set
    /// 添加 cancellable 到集合
    func addCancellable(cancellable: AnyCancellable) {
        cancellable.store(in: &self.cancellables)
    }
    
    /// Cancel all requests
    /// 取消所有請求
    func cancelAllRequests() {
        self.cancellables.forEach {
            $0.cancel()
        }
        self.cancellables.removeAll()
    }
    
    /// Perform network request and return decoded response as a Combine publisher
    /// - Parameters:
    ///   - endpoint: API endpoint model API端點模型
    ///   - httpMethod: HTTP request method (POST or GET) HTTP請求方法]
    ///   - model: Decodable type for response decoding 回應解碼的Decodable型別
    /// - Returns: A publisher emitting decoded API response or error
    func fetchRequest<T: Decodable>(
        endpoint: HWEndpointModel,
        httpMethod: HWHttpMethod = .get,
        model: T.Type
    ) -> AnyPublisher<HWAPIBaseModel<T>, HWError> {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 60
        
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        return session.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw HWError.networkConnectionFailed(reason: .other(error: URLError(.badServerResponse)))
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    let httpErrorCode = httpResponse.statusCode > 499 ? "A-5000" : "A-4000"
                    throw HWError.networkConnectionFailed(reason: .httpCode(code: httpErrorCode))
                }
                return data
            }
            .mapError { error -> HWError in
                if let mcError = error as? HWError {
                    return mcError
                }
                else if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        return HWError.networkConnectionFailed(reason: .notConnectedToInternet)
                    case .timedOut, .networkConnectionLost:
                        return HWError.networkConnectionFailed(reason: .timedOut)
                    case .cannotFindHost, .cannotConnectToHost:
                        return HWError.networkConnectionFailed(reason: .other(error: urlError))
                    default:
                        return HWError.networkConnectionFailed(reason: .other(error: urlError))
                    }
                }
                return HWError.networkConnectionFailed(reason: .other(error: error))
            }
            .flatMap { data -> AnyPublisher<HWAPIBaseModel<T>, HWError> in
                let decoder = JSONDecoder()
                return Just(data)
                    .decode(type: HWAPIBaseModel<T>.self, decoder: decoder)
                    .tryMap { baseModel in
                        if baseModel.msgCode == HWMessageCode.success.rawValue {
                            return baseModel
                        }
                        else {
                            // 丟出 DecodingError，自定義 context 用於辨識
                            throw DecodingError.dataCorrupted(.init(
                                codingPath: [],
                                debugDescription: "Decoding failed with msgCode: \(baseModel.msgCode)",
                                underlyingError: nil
                            ))
                        }
                    }
                    .mapError { error -> HWError in
                    if let decodingError = error as? DecodingError {
                        // Try to decode MCAPIErrorModel from data
                        HWLog.infoPrint(error)
                        if let apiError: HWAPIErrorModel = try? decoder.decode(HWAPIErrorModel.self, from: data) {
                            if apiError.msgCode == HWMessageCode.success.rawValue {
                                return HWError.networkDecodeFailed(reason: .decode(error: decodingError))
                            }
                            else {
                                return HWError.deCodeErrorModel(model: apiError)
                            }
                        }
                        else {
                            return HWError.networkDecodeFailed(reason: .decode(error: decodingError))
                        }
                    }
                    return HWError.networkConnectionFailed(reason: .other(error: error))
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

extension HWNetworkManager {
    func fetchRequestAsync<T: Decodable>(
        endpoint: HWEndpointModel,
        httpMethod: HWHttpMethod = .get,
        model: T.Type
    ) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            let cancellable = fetchRequest(endpoint: endpoint, httpMethod: httpMethod, model: model)
                .sink { completion in
                    if case .failure(let error) = completion {
                        continuation.resume(throwing: error)
                    }
                } receiveValue: { response in
                    continuation.resume(returning: response.result)
                }
            self.addCancellable(cancellable: cancellable)
        }
    }
}
