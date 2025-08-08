//
//  HWEndpointModel.swift
//  HomeWork
//
//  Created by JoshipTy on 3/8/25.
//

import Foundation

struct HWEndpointModel {
    let url: URL
    
    static let banners = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/banner.json")!)
    
    static let nonEmptyFavoriteList = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/favoriteList.json")!)
    static let emptyFavoriteList = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/emptyFavoriteList.json")!)
    
    static let nonEmptyNotification = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/notificationList.json")!)
    static let emptyNotification = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/emptyNotificationList.json")!)
    
    static let khrSavings = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/khrSavings1.json")!)
    static let khrFixedDeposits = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/khrFixed1.json")!)
    static let khrDigitalAccounts = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/khrDigital1.json")!)
    
    static let usdSavings = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/usdSavings1.json")!)
    static let usdFixedDeposits = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/usdFixed1.json")!)
    static let usdDigitalAccounts = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/usdDigital1.json")!)
    
    static let refreshKhrSavings = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/khrSavings2.json")!)
    static let refreshKhrFixedDeposits = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/khrFixed2.json")!)
    static let refreshKhrDigitalAccounts = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/khrDigital2.json")!)
    
    static let refreshUsdSavings = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/usdSavings2.json")!)
    static let refreshUsdFixedDeposits = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/usdFixed2.json")!)
    static let refreshUsdDigitalAccounts = HWEndpointModel(url: URL(string: "https://willywu0201.github.io/data/usdDigital2.json")!)
}

extension HWEndpointModel {
    
}


//enum HWEndpointChannel: String {
//    case data = "data/"
//}
//
//struct HWEndpointModel {
//    
//    let scheme = "https"
//    let host = "merchantapput.cathaybkdev.com.tw"
//    let path = ""
//    
//    /// API channel.
//    var channel: HWEndpointChannel
//    
//    /// API ID.
//    var apiID: String
//    
//    /// Complete URL.
//    var url: URL {
//        var components = URLComponents()
//        components.scheme = scheme
//        components.host = host
//        components.path = "/" + self.channel.rawValue + self.apiID
//        
//        if let url = components.url {
//            return url
//        }
//        else {
//            fatalError("Invalid URL components / 無效的 URL 組件: \(components)")
//        }
//    }
//    
//}
