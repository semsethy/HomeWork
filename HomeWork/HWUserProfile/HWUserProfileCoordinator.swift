//
//  HWUserProfileCoordinator.swift
//  HomeWork
//
//  Created by JoshipTy on 3/8/25.
//

import SwiftUI

class HWUserProfileCoordinator: HWNavigationCoordinatorProtocol {
    
    /// Navigation path binding controlling the current navigation stack
    /// 控制當前導航堆疊的路徑綁定
    @Binding var path: NavigationPath
    /// Currently presented sheet in the notification module
    /// 通知模組中當前顯示的底部頁面
    @Published var sheet: HWBaseSheet?
    /// Currently presented full screen cover in the notification module
    /// 通知模組中當前顯示的全螢幕畫面
    @Published var fullScreenCover: HWBaseFullScreenCover?
    
    /// Initializes the notification coordinator with navigation path binding
    /// 使用導航路徑綁定初始化通知協調器
    /// - Parameter path: Binding to the navigation path used for view stack management
    init(path: Binding<NavigationPath>) {
        self._path = path
    }
    
    /// Pushes a notification screen onto the navigation stack
    /// 將通知畫面推入導航堆疊
    /// - Parameter screen: The notification screen to navigate to
    func push(_ screen: HWUserProfileScreen) {
        self.path.append(screen)
    }
    
    /// Pops all screens, returning to the root of the navigation stack
    /// 彈出所有畫面，返回導航堆疊根目錄
    func popToRoot() {
        guard !self.path.isEmpty else {
            return
        }
        self.path.removeLast(self.path.count)
    }
    
    /// Pops the most recent screen, returning to the previous screen
    /// 彈出最近一個畫面，返回上一層
    func popToPrevious() {
        guard !self.path.isEmpty else {
            return
        }
        self.path.removeLast()
    }
    
    /// Dismisses any currently presented sheet
    /// 關閉當前顯示的底部頁面
    func dismissSheet() {
        self.sheet = nil
    }
    
    /// Logs when notification coordinator is deallocated
    /// 通知協調器釋放時記錄日誌
    deinit {
        HWLog.debugPrint("HWUserProfileCoordinator deinit")
    }
    
    // MARK: - Presentation Style Providers
    /// Builds and returns the appropriate view for a given notification screen
    /// 根據指定的通知畫面建構並返回對應的檢視
    /// - Parameter screen: The notification screen to display
    /// - Returns: Corresponding view for the screen
    @ViewBuilder
    func build(_ screen: HWUserProfileScreen) -> some View {
        
    }
}

// MARK: - MCNotificationScreen
/// Enumeration defining navigable screens within the notification module
/// 定義通知模組內可導航畫面的列舉
enum HWUserProfileScreen: Hashable {
    case home, other
}

extension HWUserProfileScreen {
    /// Extension providing equality comparison and hashing for notification screens
    /// 提供通知畫面的等值比較與雜湊運算的擴展
    static func == (lhs: HWUserProfileScreen, rhs: HWUserProfileScreen) -> Bool {
        switch (lhs, rhs) {
        case (.home, .home):
            return true
        case (.other, .other):
            return true
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .home:
            hasher.combine("home")
        case .other:
            hasher.combine("other")
        }
    }
}
