//
//  HWNetworkManager.swift
//  HomeWork
//
//  Created by JoshipTy on 3/8/25.
//

import Foundation
import Combine

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
    ///   - httpMethod: HTTP request method (POST or GET) HTTP請求方法
    ///   - httpBodyDict: Request body dictionary 請求主體字典
    ///   - verifyData: Optional verification data 附加驗證資料
    ///   - otherHttpHeader: Optional additional HTTP headers 額外HTTP標頭
    ///   - model: Decodable type for response decoding 回應解碼的Decodable型別
    /// - Returns: A publisher emitting decoded API response or error
    func fetchRequest<T: Decodable>(
        endpoint: HWEndpointModel,
        httpMethod: HWHttpMethod = .get,
        httpBodyDict: [String: Any]? = nil,
        verifyData: [String: Any]? = nil,
        otherHttpHeader: [String: String]? = nil,
        model: T.Type
    ) -> AnyPublisher<HWAPIBaseModel<T>, HWError> {
        
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // Custom headers
        otherHttpHeader?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Body
        if let body = httpBodyDict {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                return Fail(error: HWError.encodingFailed).eraseToAnyPublisher()
            }
        }
        
        // Network
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw HWError.serverError
                }
                return result.data
            }
            .decode(type: HWAPIBaseModel<T>.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? DecodingError {
                    return HWError.decodingFailed(error)
                } else if let error = error as? HWError {
                    return error
                } else {
                    return HWError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
