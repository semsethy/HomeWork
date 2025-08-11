//
//  HWHomeView.swift
//  HomeWork
//
//  Created by JoshipTy on 3/8/25.
//

import SwiftUI

struct HWHomeView: View {
    
    // Home coordinator / 首頁協調器
    @EnvironmentObject private var homeCoordinator: HWHomeCoordinator
    
    @StateObject private var viewModel = HWHomeViewModel()
    
    @State private var showTotalAmount: Bool = false
    
    @State private var isLoading: Bool = false
    
    @State private var hasNotification: Bool = false
    
    @State private var favoriteItems: [String] = []
     
    let items: [HWServiceItems] = [
        HWServiceItems(icon: "button00ElementMenuTransfer", title: "Transfer"),
        HWServiceItems(icon: "button00ElementMenuPayment", title: "Payment"),
        HWServiceItems(icon: "button00ElementMenuUtility", title: "Utility"),
        HWServiceItems(icon: "button01Scan", title: "QR pay scan"),
        HWServiceItems(icon: "button00ElementMenuQRcode", title: "My QR code"),
        HWServiceItems(icon: "button00ElementMenuTopUp", title: "Top up")
    ]
      
    var isReady: Bool {
        viewModel.isLoadingFavorite || viewModel.isLoadingBanners || viewModel.isLoadingBalance
    }
    @State private var delayCompleted = false
    var showContent: Bool {
        isReady && delayCompleted
    }
    
    var body: some View {
        ZStack {
            // MARK: - Background
            ZStack {
                Image("Bg")
                    .resizable()
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
            }
            .edgesIgnoringSafeArea(.all)
 
            VStack(spacing: 0) {
                // MARK: - Toolbar
                HWToolBar(onUserProfileAction: {
                    self.homeCoordinator.push(.userProfileView(path: self.$homeCoordinator.path))
                }, onNotificationAction: {
                    self.homeCoordinator.push(.notificationsView(notificationList: self.$homeCoordinator.notificationArray, isRefresh: self.$homeCoordinator.isRefresh, path: self.$homeCoordinator.path))
                }, hasNotification: $hasNotification)
                
                VStack(spacing: 4) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 18) {
                            
                            HStack {
                                Text("My Account Balance")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                Button {
                                    showTotalAmount.toggle()
                                } label: {
                                    Image(systemName: showTotalAmount ? "eye" : "eye.slash")
                                        .frame(width: 22.0, height: 15.0)
                                        .foregroundStyle(Color(red: 251.0 / 255.0, green: 108.0 / 255.0, blue: 72.0 / 255.0))
                                }
                                Spacer()
                            }
                            
                            VStack(alignment: .leading,spacing: 8) {
                                Text("USD")
                                    .font(.callout)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.trailing)
                                
                                if !showContent {
                                    HWSkimmerEffectBoxView()
                                        .frame(height: 30)
                                        .cornerRadius(4)
                                } else {
                                    Text(showTotalAmount ? viewModel.totalUSD.formatted(.currency(code: "USD")) : "*********")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                        .fontWeight(.medium)
                                        .frame(height: 30)
                                }
                                
                                Text("KHR")
                                    .font(.callout)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.trailing)
                                
                                if !showContent {
                                    HWSkimmerEffectBoxView()
                                        .frame(height: 30)
                                        .cornerRadius(4)
                                } else {
                                    Text(showTotalAmount ? viewModel.totalKHR.formatted(.currency(code: "KHR")) : "*********")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                        .fontWeight(.medium)
                                        .frame(height: 30)
                                }
                            }
                            .opacity(0.8)
                            
                            LazyVGrid(columns: [GridItem(),GridItem(),GridItem()],spacing: 20) {
                                ForEach(items.indices, id: \.self) { index in
                                    HWServiceIconView(serviceItem: items[index])
                                }
                            }
                            .padding(.bottom, 14)
                            
                            HStack {
                                Text("My Favorite")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Button {
                                    
                                } label: {
                                    HStack(spacing: 4) {
                                        Text("More")
                                            .foregroundStyle(.black)
                                        Image("iconArrow01Next")
                                    }
                                }
                                .foregroundStyle(.primary)
                            }
                             
                            if !showContent {
                                HWSkimmerEffectBoxView()
                                    .frame(height: 100)
                                    .cornerRadius(10)
                            }
                            else if viewModel.isFavoriteEmpty {
                                self.emptyFavoriteSection
                                    .cornerRadius(10)
                            } else {
                                // MARK: - Horizontal scrollable favorite list
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(viewModel.displayItems) { item in
                                            HWFavoriteIconView(item: item)
                                        }
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                            if !showContent {
                                HWSkimmerEffectBoxView()
                                    .frame(height: 100)
                                    .cornerRadius(10)
                            } else {
                                HWImageSliderView(currentPage: $viewModel.currentBannerIndex, banners: viewModel.banners)
                            }
                        }
                        .padding(24)
                        .padding(.bottom, 44)
                    }
                    .refreshable {
                        viewModel.isRefresh = true
                        homeCoordinator.isRefresh = true
                        await viewModel.fetchFavoriteList()
                        await viewModel.fetchBanners()
                        await viewModel.fetchSumAccountsCurrency()
                        self.hasNotification = true
                    }
                }
            }
            .task {
                // Start 3s timer in parallel
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        delayCompleted = true
                    }
                }
                await viewModel.fetchFavoriteList()
                await viewModel.fetchBanners()
                await viewModel.fetchSumAccountsCurrency()
            }
        }
    }
     
    /// Loading section view
    private var loadingTypeSection: some View {
        VStack(spacing: 8) {
            Rectangle()
                .foregroundStyle(Color.gray200)
                .cornerRadius(3)
        }
    }
    
    /// Empty favorite view
    private var emptyFavoriteSection: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray200).opacity(0.4)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
            HStack{
                
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
    }
}
 
#Preview {
    CustomTabMainView()
}
     
     
    
     
   
  
 
  
