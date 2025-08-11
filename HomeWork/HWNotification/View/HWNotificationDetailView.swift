//
//  HWNotificationDetailView.swift
//  HomeWork
//
//  Created by JoshipTy on 3/8/25.
//

import SwiftUI

struct HWNotificationDetailView: View {
    
    @EnvironmentObject var coordinator: HWNotificationCoordinator
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    HWNotificationDetailView()
}
