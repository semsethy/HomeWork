//
//  HWImageSliderView.swift
//  HomeWork
//
//  Created by JoshipTy on 4/8/25.
//

import SwiftUI

struct HWImageSliderView: View {
    
    @Binding var currentPage: Int
    
    let images: [UIImage]
    
    let height: CGFloat = 100
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 8) {
            
            // MARK: - Image Slider
            TabView(selection: $currentPage) {
                ForEach(images.indices, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .scaledToFill()
                        .frame(height: height)
                        .clipped()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: height)
            .cornerRadius(10)
            .onReceive(timer) { _ in
                guard !images.isEmpty else { return }
                withAnimation {
                    currentPage = (currentPage + 1) % images.count
                }
            }
            
            // MARK: - Custom Page Indicator
            HStack(spacing: 6) {
                ForEach(images.indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.black : Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 4)
        }
    }
}
