//
//  HWNotificationCoordinatorView.swift
//  HomeWork
//
//  Created by JoshipTy on 2/8/25.
//

import SwiftUI

struct HWNotificationCoordinatorView: View {
    
    /// StateObject managing notification-specific navigation and state
    /// 管理通知導航與狀態的 StateObject
    @StateObject var notificationCoordinator: HWNotificationCoordinator
    
    /// Initialize notification coordinator view with navigation path binding
    /// 使用導航路徑綁定初始化通知協調器畫面
    /// - Parameter path: Binding to the navigation path for managing view stack
    init(path: Binding<NavigationPath>) {
        self._notificationCoordinator = StateObject(wrappedValue: HWNotificationCoordinator(path: path))
    }
    
    var body: some View {
        self.notificationCoordinator.build(.home)
            .navigationDestination(for: HWNotificationScreen.self) { screen in
                self.notificationCoordinator.build(screen)
                    .environmentObject(self.notificationCoordinator)
            }
            .environmentObject(self.notificationCoordinator)
    }
}

#Preview {
    HWNotificationCoordinatorView(path: .constant(NavigationPath()))
}
