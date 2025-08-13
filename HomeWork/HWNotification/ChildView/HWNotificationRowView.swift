//
//  NotificationRowView.swift
//  HomeWork
//
//  Created by JoshipTy on 2/8/25.
//

import SwiftUI

struct HWNotificationRowView: View {
    
    @Binding var item: HWNotificationMessage

    var body: some View {
        VStack(alignment: .leading, spacing: 4) { 
            ZStack(alignment: .topLeading) {
                Text(item.title)
                    .font(.subheadline)
                    .foregroundColor(Color.black)
                    .bold()
                    .dynamicTypeSize(.xSmall...DynamicTypeSize.xxxLarge)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                if item.status {
                    Circle()
                        .fill(Color(red: 251.0 / 255.0, green: 108.0 / 255.0, blue: 72.0 / 255.0))
                        .frame(width: 8, height: 8)
                        .offset(x: -10, y: 5) // adjust this for perfect positioning
                }
            }
            
            Text(item.updateDateTime.normalizedDateString())
                .font(.caption)
                .foregroundColor(Color.black)
                .dynamicTypeSize(.xSmall...DynamicTypeSize.xxxLarge)
                .multilineTextAlignment(.leading)
            
            Text(item.message)
                .font(.caption)
                .foregroundColor(Color.gray)
                .dynamicTypeSize(.xSmall...DynamicTypeSize.xxxLarge)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


