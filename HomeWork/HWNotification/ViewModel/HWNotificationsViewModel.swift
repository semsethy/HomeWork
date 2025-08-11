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
    
    // MARK: - Published Properties
    @Published var notificationList: [HWNotificationMessage]
    @Published var isRefresh: Bool
    @Published var showNavBarBackground: Bool = true
    @Published var listType: HWNotificationListType = .loading
    
    // MARK: - Private Properties
    private var rawScrollOffset: CGFloat = 60
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(notificationList: [HWNotificationMessage], isRefresh: Bool) {
        self.notificationList = notificationList
        self.isRefresh = isRefresh
    }
    
    // MARK: - Scroll Offset Handler
    func updateScrollOffset(_ newValue: CGFloat) {
        let previouslyShowingBackground = self.rawScrollOffset < 50
        let shouldShowBackground = newValue < 50
        self.rawScrollOffset = newValue
        if previouslyShowingBackground != shouldShowBackground {
            self.showNavBarBackground = shouldShowBackground
        }
    }
    
    // MARK: - Call from Home Refresh
    func fetchNotification() {
        let endpoint: HWEndpointModel = isRefresh ? .nonEmptyNotification : .emptyNotification
        self.fetchNotification(from: endpoint) { result in
            switch result {
            case .success(let response):
                self.notificationList = response.result.messages
                self.listType = self.notificationList.isEmpty ? .empty : .normal
            case .failure(let error):
                print("Notification error: \(error)")
                self.listType = .retry
            }
        }
    }
}

// MARK: - API Request
extension HWNotificationsViewModel {
    private func fetchNotification(
        from endpoint: HWEndpointModel,
        completion: @escaping (Result<HWAPIBaseModel<HWNotificationResult>, HWError>) -> Void
    ) {
        let publisher = HWNetworkManager.shared.fetchRequest(
            endpoint: endpoint,
            httpMethod: .get,
            model: HWNotificationResult.self
        )

        let cancellable = publisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { receiveCompletion in
                    switch receiveCompletion {
                    case .failure(let error):
                        completion(.failure(error))
                    case .finished:
                        break
                    }
                },
                receiveValue: { response in
                    completion(.success(response))
                }
            )
        HWNetworkManager.shared.addCancellable(cancellable: cancellable)
    }
}
