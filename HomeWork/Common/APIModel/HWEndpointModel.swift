//
//  HWEndpointModel.swift
//  HomeWork
//
//  Created by JoshipTy on 3/8/25.
//

import Foundation

enum HWEndpointChannel: String {
    case data = "data/"
}

struct HWEndpointModel {
    
    let scheme = "https"
    let host = "willywu0201.github.io"
    let path = ""
    
    /// API channel.
    var channel: HWEndpointChannel
    
    /// API ID.
    var apiID: String
    
    /// Complete URL.
    var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = "/" + self.channel.rawValue + self.apiID + ".json"
        
        if let url = components.url {
            return url
        }
        else {
            fatalError("Invalid URL components / 無效的 URL 組件: \(components)")
        }
    }
}
