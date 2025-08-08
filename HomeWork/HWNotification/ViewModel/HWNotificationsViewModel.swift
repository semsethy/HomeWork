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
    
    static let shared = HWNotificationsViewModel()
    
    @Published var notification: [HWNotificationMessage] = []
    
    @Published var useRefreshData: Bool = false
    
    @Published var hasNotification: Bool = false
    
    /// Raw scroll offset for controlling navigation bar background visibility
    /// 控制導航列背景顯示的原始滾動偏移量
    private var rawScrollOffset: CGFloat = 60
    
    /// Controls whether the navigation bar background is visible based on scroll position
    /// 根據滾動位置控制導航列背景是否顯示
    @Published var showNavBarBackground: Bool = true
    
    /// Current API loading state determining view content display
    /// 目前的 API 載入狀態，控制畫面內容呈現
    @Published var listType: HWNotificationListType = .loading
    
    /// Stores Combine cancellables for API subscription management
    /// 儲存 Combine 取消項目，用於管理 API 訂閱
    var cancellables = Set<AnyCancellable>()
    
    /// Updates scroll offset and triggers navigation bar background change when threshold crossed
    /// 更新滾動偏移量並在越過閾值時觸發導航列背景變化
    func updateScrollOffset(_ newValue: CGFloat) {
        let previouslyShowingBackground = self.rawScrollOffset < 50
        let shouldShowBackground = newValue < 50
        self.rawScrollOffset = newValue
        if previouslyShowingBackground != shouldShowBackground {
            self.showNavBarBackground = shouldShowBackground
        }
    }
}

// MARK: - API
extension HWNotificationsViewModel {
    // MARK: - Call from Home Refresh (refreshable)
    func fetchNonEmptyNotification() async {
        await fetchNotification(from: useRefreshData ? HWEndpointModel.nonEmptyNotification : HWEndpointModel.emptyNotification)
    }

    private func fetchNotification(from endpoint: HWEndpointModel) async {
        HWNetworkManager.shared.fetchRequest(
            endpoint: endpoint,
            httpMethod: .get,
            model: HWNotificationResult.self
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case .failure(let error) = completion {
                print("Notification error: \(error)")
                self.listType = .retry
            }
        } receiveValue: { response in
            self.notification = response.result.messages
            self.listType = self.notification.isEmpty ? .empty : .normal
        }
        .store(in: &cancellables)
    }
}

