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
    
    func fetchRequest<T: Decodable>(
        endpoint: HWEndpointModel,
        httpMethod: HWHttpMethod = .get,
        model: T.Type
    ) async throws -> HWAPIBaseModel<T> {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 60
        
        let (data, response) = try await URLSession(configuration: config)
            .data(for: URLRequest(url: endpoint.url))
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw HWError.networkConnectionFailed(reason: .other(error: URLError(.badServerResponse)))
        }
        
        let decoder = JSONDecoder()
        let baseModel = try decoder.decode(HWAPIBaseModel<T>.self, from: data)
        
        if baseModel.msgCode != HWMessageCode.success.rawValue {
            throw HWError.deCodeErrorModel(model: try decoder.decode(HWAPIErrorModel.self, from: data))
        }
        
        return baseModel
    }
}
