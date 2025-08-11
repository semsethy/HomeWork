//
//  HWOptionIconView.swift
//  HomeWork
//
//  Created by JoshipTy on 3/8/25.
//

import SwiftUI

struct HWServiceItems {
    let icon: String
    let title: String
}

struct HWServiceIconView: View {
    
    var serviceItem: HWServiceItems
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Image(serviceItem.icon)
                .resizable()
                .frame(width: 66, height: 66)
                .scaledToFit()
                .foregroundColor(.clear)
            
            Text(serviceItem.title)
                .font(.subheadline)
                .dynamicTypeSize(.xSmall...DynamicTypeSize.xxxLarge)
                .minimumScaleFactor(0.2)
                .lineLimit(1)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    HWServiceIconView(serviceItem: HWServiceItems(icon: "ic_cubc_mbanking", title: "CUBC"))
}
