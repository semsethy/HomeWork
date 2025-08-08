//
//  HWNetworkManager.swift
//  HomeWork
//
//  Created by JoshipTy on 3/8/25.
//

import Foundation
import Combine

enum HWHttpMethod: String {
    case get = "GET"
    case post = "POST"
}

class HWNetworkManager: NSObject, URLSessionDelegate {
    
    static let shared = HWNetworkManager()
    
    private override init() { }
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchRequest<T: Decodable>(
        endpoint: HWEndpointModel,
        httpMethod: HWHttpMethod = .get,
        httpBodyDict: [String: Any]? = nil,
        verifyData: [String: Any]? = nil, // Not used for now
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
