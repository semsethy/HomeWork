//
//  HWFavoriteIconView.swift
//  HomeWork
//
//  Created by JoshipTy on 3/8/25.
//

import SwiftUI

struct HWFavoriteIconView: View {
    
    @Binding var item: FavoriteDisplayItem
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(self.item.type.icon)
                .resizable()
                .frame(width: 66, height: 66)
                .scaledToFit()
                .foregroundColor(.clear)
                .clipShape(Circle())
            
            Text(self.item.nickname)
                .font(.subheadline)
                .dynamicTypeSize(.xSmall...DynamicTypeSize.xxxLarge)
                .minimumScaleFactor(0.2)
                .lineLimit(1)
                .foregroundStyle(.black)
        }
        .frame(height: 100)
    }
}

#Preview {
    HWFavoriteIconView(item: .constant(.init(type: .creditCard, nickname: "Andy")))
}
