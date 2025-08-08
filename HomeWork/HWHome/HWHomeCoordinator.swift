//
//  HWHomeCoordinator.swift
//  HomeWork
//
//  Created by JoshipTy on 2/8/25.
//

import SwiftUI

class HWHomeCoordinator: HWNavigationCoordinatorProtocol {
    
    /// Navigation path for stack navigation
    @Published var path: NavigationPath = NavigationPath()
    /// Sheet presentation state
    @Published var sheet: HWBaseSheet?
    
    // MARK: - Navigation Actions
    /// Push a new screen onto the navigation stack
    func push(_ screen: HWHomeScreen) {
        self.path.append(screen)
    }
    /// Dismiss the sheet
    func dismissSheet() {
        self.sheet = nil
    }
    
    deinit {
        HWLog.debugPrint("HWHomeCoordinator deinit")
    }
    
    // MARK: - Presentation Style Providers
    /// Build view for a given home screen
    @ViewBuilder
    func build(_ screen: HWHomeScreen) -> some View {
        switch screen {
        case .home:
            HWHomeView()
        case .userProfileView(path: let path):
            HWUserProfileCoordinatorView(path: path)
        case .notificationsView(path: let path):
            HWNotificationCoordinatorView(path: path)
        }
    }
}

// MARK: - MCHomeScreen
/// Enum for home navigation screens
enum HWHomeScreen: Hashable {
    /// Home main screen
    case home
    /// User Profile record view
    case userProfileView(path: Binding<NavigationPath>)
    /// Notifications record view
    case notificationsView(path: Binding<NavigationPath>)
}

extension HWHomeScreen {
    static func == (lhs: HWHomeScreen, rhs: HWHomeScreen) -> Bool {
        switch (lhs, rhs) {
        case (.home, .home):
            return true
        case (.userProfileView, .userProfileView):
            return true
        case (.notificationsView, .notificationsView):
            return true
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .home:
            hasher.combine("home")
        case .userProfileView:
            hasher.combine("userProfileView")
        case .notificationsView:
            hasher.combine("notificationsView")
        }
    }
}

