//
//  HWFavoriteIconView.swift
//  HomeWork
//
//  Created by JoshipTy on 3/8/25.
//

import SwiftUI

struct HWFavoriteIconView: View {
    
    var item: FavoriteDisplayItem
    
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
                .foregroundStyle(.primary)
        }
        .frame(height: 100)
    }
}

#Preview {
    HWFavoriteIconView(item: .init(type: .creditCard, nickname: "hi"))
}
