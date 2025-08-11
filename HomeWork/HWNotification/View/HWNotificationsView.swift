//
//  HWNotificationsView.swift
//  HomeWork
//
//  Created by JoshipTy on 2/8/25.
//

import SwiftUI

struct HWNotificationsView: View {
    
    @StateObject private var viewModel: HWNotificationsViewModel
    
    @EnvironmentObject private var notificationCoordinator: HWNotificationCoordinator
    
    init(notificationList: [HWNotificationMessage], isRefresh: Bool){
        let viewModel = HWNotificationsViewModel(notificationList: notificationList, isRefresh: isRefresh)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // 背景圖片
                self.backgroundView()
                
                // nav bar 上面的狀態欄白色背景
                self.statusBarBackground(geometry: geometry)
                
                VStack(spacing: 0) {
                    // NavigationBar
                    self.customNavigationBar()
                
                    self.mainContentView()
                }
                .onPreferenceChange(MCScrollOffsetPreferenceKey.self) { value in
                    self.handleScrollOffset(value)
                }
            }
        }
        .onAppear {
            viewModel.fetchNotification()
        }
        .onDisappear {
            self.viewModel.cancellables.removeAll()
        }
        .navigationBarHidden(true)
    }
    
    /// Renders the background image for notifications view
    private func backgroundView() -> some View {
        Image("notification_background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    /// Displays white background behind the device status bar when necessary
    private func statusBarBackground(geometry: GeometryProxy) -> some View {
        Rectangle()
            .fill(Color.white)
            .opacity(self.viewModel.showNavBarBackground ? 1 : 0)
            .animation(.easeInOut(duration: 0.2), value: self.viewModel.showNavBarBackground)
            .frame(height: geometry.safeAreaInsets.top)
            .edgesIgnoringSafeArea(.top)
    }
    
    /// Custom navigation bar showing back button and title for notifications
    private func customNavigationBar() -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .opacity(self.viewModel.showNavBarBackground ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: self.viewModel.showNavBarBackground)
                .frame(height: 44)
            
            HStack {
                Button(action: {
                    self.notificationCoordinator.pop()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.black)
                        .padding(.leading, 24)
                        .fontWeight(.regular)
                }
                
                Spacer()
                
                Text("Notification")
                    .font(.title3)
                    .dynamicTypeSize(.large)
                    .foregroundStyle(Color.black)
                
                Spacer()
                
                Color.clear
                    .frame(width: 25, height: 25)
                    .padding(.trailing, 24)
            }
        }
    }
    
    /// Displays appropriate content based on current list state (empty, retry, loading, or normal)
    private func mainContentView() -> some View {
        Group {
            self.scrollableContentView()
        }
    }
    
    /// Scrollable list displaying loading skeletons or notification items
    private func scrollableContentView() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                self.normalView()
            }
            .padding(.bottom, 80)
            .overlay(
                GeometryReader { offsetGeometry in
                    Color.clear.preference(key: MCScrollOffsetPreferenceKey.self,
                                          value: offsetGeometry.frame(in: .global).minY)
                }
            )
        }
    }
    
    /// Normal view displaying grouped notifications with section headers
    private func normalView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(viewModel.notificationList, id: \.id) { item in
                HWNotificationRowView(item: item)
            }
            .background(Color.white)
            .cornerRadius(8)
            .padding(.top, 8)
            .padding(.bottom, 6)
        }
        .padding(.horizontal, 16)
    }
    
    /// Handles scroll offset changes to update navbar appearance
    private func handleScrollOffset(_ value: CGFloat) {
        // retry 和 empty 狀態不需要更新滑動
        guard self.viewModel.listType == .loading || self.viewModel.listType == .normal else {
            return
        }
        self.viewModel.updateScrollOffset(value)
    }
}

//#Preview {
//    HWNotificationsView(notificationList: <#[HWNotificationMessage]#>)
//}

