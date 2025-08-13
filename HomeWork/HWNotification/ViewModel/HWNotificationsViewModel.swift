//
//  HWNotificationsViewModel.swift
//  HomeWork
//
//  Created by JoshipTy on 2/8/25.
//

import SwiftUI
import Combine

// MARK: - Notification List Type
enum HWNotificationListType {
    case loading
    case retry
    case empty
    case normal
}

// MARK: - HWNotificationsViewModel
class HWNotificationsViewModel: ObservableObject {
    
    /// MARK: - Published Properties
    @Published var notificationList: [HWNotificationMessage]
    @Published var isRefresh: Bool
    @Published var showNavBarBackground: Bool = true
    @Published var listType: HWNotificationListType = .loading
    
    /// MARK: - Private Properties
    private var rawScrollOffset: CGFloat = 60
    var cancellables = Set<AnyCancellable>()
    
    /// MARK: - Initializer
    init(notificationList: [HWNotificationMessage], isRefresh: Bool) {
        self.notificationList = notificationList
        self.isRefresh = isRefresh
    }
    
    /// MARK: - Scroll Offset Handler
    func updateScrollOffset(_ newValue: CGFloat) {
        let previouslyShowingBackground = self.rawScrollOffset < 50
        let shouldShowBackground = newValue < 50
        self.rawScrollOffset = newValue
        if previouslyShowingBackground != shouldShowBackground {
            self.showNavBarBackground = shouldShowBackground
        }
    }
}

// MARK: - API Request
extension HWNotificationsViewModel {
    // MARK: - Call from Home Refresh
    @MainActor
    func fetchNotification() async {
        Task { [weak self] in
            guard let self else { return }
            let endpoint: HWEndpointModel = isRefresh ? .nonEmptyNotification : .emptyNotification
            
            do {
                let response: HWAPIBaseModel<HWNotificationResult> =
                try await HWNetworkManager.shared.fetchRequest(
                    endpoint: endpoint,
                    httpMethod: .get,
                    model: HWNotificationResult.self
                )
                
                self.notificationList = response.result.messages
                self.listType = self.notificationList.isEmpty ? .empty : .normal
            } catch {
                print("Notification error:", error)
                self.listType = .retry
            }
        }
    }
}
