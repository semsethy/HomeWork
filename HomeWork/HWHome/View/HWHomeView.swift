//
//  HWHomeView.swift
//  HomeWork
//
//  Created by JoshipTy on 3/8/25.
//

import SwiftUI

/// Home screen view displaying account balances, services, favorites, and a banner image slider.
struct HWHomeView: View {
    
    // MARK: - Environment & State
    @EnvironmentObject private var homeCoordinator: HWHomeCoordinator
    @StateObject private var viewModel = HWHomeViewModel()
    
    @State private var showTotalAmount: Bool = false
    @State private var hasNotification: Bool = false
    @State private var delayCompleted = false
    
    /// Loading indicator for various data fetching states
    private var isReady: Bool {
        !viewModel.isLoadingFavorite &&
        !viewModel.isLoadingBanners &&
        !viewModel.isLoadingBalance
    }
    
    /// Determines if UI content should be displayed
    private var showContent: Bool {
        isReady && delayCompleted
    }
    
    /// Predefined service menu items
    private let serviceItems: [HWServiceItems] = [
        HWServiceItems(icon: "button00ElementMenuTransfer", title: "Transfer"),
        HWServiceItems(icon: "button00ElementMenuPayment", title: "Payment"),
        HWServiceItems(icon: "button00ElementMenuUtility", title: "Utility"),
        HWServiceItems(icon: "button01Scan", title: "QR pay scan"),
        HWServiceItems(icon: "button00ElementMenuQRcode", title: "My QR code"),
        HWServiceItems(icon: "button00ElementMenuTopUp", title: "Top up")
    ]
    
    // MARK: - Body
    var body: some View {
        ZStack {
            backgroundView
            
            VStack(spacing: 0) {
                toolbarSection
                
                VStack(spacing: 4) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 18) {
                            accountBalanceSection
                            serviceMenuSection
                            favoriteSection
                            bannerSection
                        }
                        .padding(24)
                        .padding(.bottom, 44)
                    }
                    .refreshable {
                        viewModel.isRefresh = true
                        homeCoordinator.isRefresh = true
                        hasNotification = true
                        await viewModel.fetchFavoriteList()
                        viewModel.fetchBanners()
                        try? await viewModel.fetchSumAccountsCurrency()
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.isShowingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage ?? "Unknown error")
            }
            .task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        delayCompleted = true
                    }
                }
                await viewModel.fetchFavoriteList()
                viewModel.fetchBanners()
                try? await viewModel.fetchSumAccountsCurrency()
            }
        }
    }
}

// MARK: - Subviews
private extension HWHomeView {
    
    /// Full-screen background image
    var backgroundView: some View {
        Image("Bg")
            .resizable()
            .frame(maxWidth: UIScreen.main.bounds.width,
                   maxHeight: UIScreen.main.bounds.height)
            .edgesIgnoringSafeArea(.all)
    }
    
    /// Top toolbar with profile and notification buttons
    var toolbarSection: some View {
        HWToolBar(
            onUserProfileAction: {
                homeCoordinator.push(.userProfileView(path: $homeCoordinator.path))
            },
            onNotificationAction: {
                homeCoordinator.push(.notificationsView(
                    notificationList: $homeCoordinator.notificationArray,
                    isRefresh: $homeCoordinator.isRefresh,
                    path: $homeCoordinator.path
                ))
            },
            hasNotification: $hasNotification
        )
    }
    
    /// Account balance display with show/hide toggle
    var accountBalanceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            balanceTitleRow
            currencyRow(code: "USD", amount: viewModel.totalUSD)
            currencyRow(code: "KHR", amount: viewModel.totalKHR)
        }
        .opacity(0.8)
    }
    
    /// "My Account Balance" header row
    var balanceTitleRow: some View {
        HStack {
            Text("My Account Balance")
                .font(.headline)
                .foregroundColor(.gray)
            
            Button {
                showTotalAmount.toggle()
            } label: {
                Image(systemName: showTotalAmount ? "eye" : "eye.slash")
                    .frame(width: 22, height: 15)
                    .foregroundStyle(Color(red: 251/255, green: 108/255, blue: 72/255))
            }
            Spacer()
        }
    }
    
    /// Currency row with loading placeholder or actual value
    func currencyRow(code: String, amount: Decimal) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(code)
                .font(.callout)
                .foregroundColor(.black)
            
            if !showContent {
                HWShimmerEffectBoxView()
                    .frame(height: 30)
                    .cornerRadius(4)
            } else {
                Text(showTotalAmount ? amount.formatted(.currency(code: code)) : "*********")
                    .font(.title2)
                    .foregroundColor(.black)
                    .fontWeight(.medium)
                    .frame(height: 30)
            }
        }
    }
    
    /// Service menu grid
    var serviceMenuSection: some View {
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], spacing: 20) {
            ForEach(serviceItems.indices, id: \.self) { index in
                HWServiceIconView(serviceItem: serviceItems[index])
            }
        }
        .padding(.bottom, 14)
    }
    
    /// Favorite section (loading, empty, or list)
    var favoriteSection: some View {
        VStack(spacing: 0) {
            sectionHeader(title: "My Favorite", actionTitle: "More") {
                // Action for "More"
            }
            
            if !showContent {
                placeholderBox(height: 100)
            }
            else if viewModel.isFavoriteEmpty {
                emptyFavoriteSection
            }
            else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach($viewModel.displayItems) { item in
                            HWFavoriteIconView(item: item)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
    
    /// Banner image slider section
    var bannerSection: some View {
        VStack(spacing: 0) {
            if !showContent {
                placeholderBox(height: 100)
            } else {
                HWImageSliderView(
                    currentPage: $viewModel.currentBannerIndex,
                    images: viewModel.bannerImages
                )
            }
        }
    }
    
    /// "Empty favorites" placeholder
    var emptyFavoriteSection: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray200.opacity(0.4))
                .frame(height: 100)
            
            HStack {
                Spacer()
                Image("button00ElementScrollEmpty")
                    .resizable()
                    .frame(width: 54, height: 54)
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("You can add a favorite through the transfer or payment function.")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
        .cornerRadius(10)
    }
}

// MARK: - UI Helpers
private extension HWHomeView {
    
    func sectionHeader(title: String, actionTitle: String, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.black)
            
            Spacer()
            
            Button(action: action) {
                HStack(spacing: 4) {
                    Text(actionTitle)
                        .foregroundStyle(.black)
                    Image("iconArrow01Next")
                }
            }
            .foregroundStyle(.primary)
        }
    }
    
    func placeholderBox(height: CGFloat) -> some View {
        HWShimmerEffectBoxView()
            .frame(height: height)
            .cornerRadius(10)
    }
}

// MARK: - Preview
#Preview {
    CustomTabMainView()
}
