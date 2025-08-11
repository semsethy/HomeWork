//
//  MCEndpointModel+EndPoint.swift
//  HomeWork
//
//  Created by JoshipTy on 5/8/25.
//

import Foundation

// MARK: - Banner Endpoints
extension HWEndpointModel {
    
    /// Endpoint for retrieving banner data
    static let banners = HWEndpointModel(channel: .data, apiID: "banner")
}

// MARK: - Favorite List Endpoints
extension HWEndpointModel {
    
    /// Endpoint for retrieving non-empty favorite list
    static let nonEmptyFavoriteList = HWEndpointModel(channel: .data, apiID: "favoriteList")
    
    /// Endpoint for retrieving empty favorite list
    static let emptyFavoriteList = HWEndpointModel(channel: .data, apiID: "emptyFavoriteList")
}

// MARK: - Notification Endpoints
extension HWEndpointModel {
    
    /// Endpoint for retrieving non-empty notification list
    static let nonEmptyNotification = HWEndpointModel(channel: .data, apiID: "notificationList")
    
    /// Endpoint for retrieving empty notification list
    static let emptyNotification = HWEndpointModel(channel: .data, apiID: "emptyNotificationList")
}

// MARK: - Account Balance Endpoints (Initial Load)
extension HWEndpointModel {
    
    /// Endpoint for retrieving KHR savings account balance
    static let khrSavings = HWEndpointModel(channel: .data, apiID: "khrSavings1")
    
    /// Endpoint for retrieving KHR fixed deposit account balance
    static let khrFixedDeposits = HWEndpointModel(channel: .data, apiID: "khrFixed1")
    
    /// Endpoint for retrieving KHR digital account balance
    static let khrDigitalAccounts = HWEndpointModel(channel: .data, apiID: "khrDigital1")

    /// Endpoint for retrieving USD savings account balance
    static let usdSavings = HWEndpointModel(channel: .data, apiID: "usdSavings1")
    
    /// Endpoint for retrieving USD fixed deposit account balance
    static let usdFixedDeposits = HWEndpointModel(channel: .data, apiID: "usdFixed1")
    
    /// Endpoint for retrieving USD digital account balance
    static let usdDigitalAccounts = HWEndpointModel(channel: .data, apiID: "usdDigital1")
}

// MARK: - Account Balance Endpoints (Refresh)
extension HWEndpointModel {
    
    /// Endpoint for refreshing KHR savings account balance
    static let refreshKhrSavings = HWEndpointModel(channel: .data, apiID: "khrSavings2")
    
    /// Endpoint for refreshing KHR fixed deposit account balance
    static let refreshKhrFixedDeposits = HWEndpointModel(channel: .data, apiID: "khrFixed2")
    
    /// Endpoint for refreshing KHR digital account balance
    static let refreshKhrDigitalAccounts = HWEndpointModel(channel: .data, apiID: "khrDigital2")

    /// Endpoint for refreshing USD savings account balance
    static let refreshUsdSavings = HWEndpointModel(channel: .data, apiID: "usdSavings2")
    
    /// Endpoint for refreshing USD fixed deposit account balance
    static let refreshUsdFixedDeposits = HWEndpointModel(channel: .data, apiID: "usdFixed2")
    
    /// Endpoint for refreshing USD digital account balance
    static let refreshUsdDigitalAccounts = HWEndpointModel(channel: .data, apiID: "usdDigital2")
}
