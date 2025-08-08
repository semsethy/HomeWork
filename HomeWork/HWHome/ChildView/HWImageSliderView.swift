//
//  HWImageSliderView.swift
//  HomeWork
//
//  Created by JoshipTy on 4/8/25.
//

import SwiftUI

struct HWImageSliderView: View {
    
    @Binding var currentPage: Int
    
    let banners: [BannerList]
    
    let height: CGFloat = 100
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 8) {
            
            // MARK: - Image Slider
            TabView(selection: $currentPage) {
                ForEach(Array(banners.enumerated()), id: \.offset) { index, banner in
                    AsyncImage(url: URL(string: banner.linkURL)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView().frame(height: height)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: height)
                        case .failure:
                            Color.gray
                                .frame(height: height)
                                .overlay(Text("Failed to load").foregroundColor(.white))
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: height)
            .cornerRadius(10)
            .onReceive(timer) { _ in
                guard !banners.isEmpty else { return }
                withAnimation {
                    currentPage = (currentPage + 1) % banners.count
                }
            }
            
            // MARK: - Custom Page Indicator
            HStack(spacing: 6) {
                ForEach(banners.indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.black : Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 4)
        }
    }
}
