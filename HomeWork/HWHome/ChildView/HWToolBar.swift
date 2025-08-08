//
//  HWToolBar.swift
//  HomeWork
//
//  Created by JoshipTy on 2/8/25.
//

import SwiftUI

// MARK: - HWToolBar
/// Toolbar view for home screens, supports various actions
struct HWToolBar: View {

    /// User Profile action handler
    var onUserProfileAction: (() -> Void)?

    /// Notification action handler
    var onNotificationAction: (() -> Void)?
    
    var useRefreshData: Bool = false
    
    var hasNotification: Bool = false
    
    // MARK: - Body
    var body: some View {
        HStack {
            // MARK: - Leading Button
            /// Leading button for toolbar (language, back, close, etc.)
            Button(action: {
                self.onUserProfileAction?()
            }) {
                Image("sethy")
                    .resizable()
                    .foregroundColor(.clear)
                    .frame(width: 40.0, height: 40.0)
                    .overlay(
                        Rectangle()
                            .stroke(Color(white: 238.0 / 255.0), lineWidth: 1.0)
                    )
                    .clipShape(Circle())
            }
 
            Spacer()

            // MARK: - Trailing Button(s)
            /// Trailing button for toolbar ( notification.)
            Button(action: {
                self.onNotificationAction?()
            }) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell")
                        .font(.system(size: 24))
                        .foregroundStyle(.black)
                    
                    if hasNotification {
                        Circle()
                            .fill(Color(red: 251.0 / 255.0, green: 108.0 / 255.0, blue: 72.0 / 255.0))
                            .frame(width: 8, height: 8)
                            .offset(x: -3, y: 3)
                    }
                }
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 24)
    }
}

//MARK: - Preview
#Preview {
    HWToolBar()
}
