//
//  HWHomeView.swift
//  HomeWork
//
//  Created by JoshipTy on 2/8/25.
//

import SwiftUI

struct HWHomeCoordinatorView: View {
    
    @StateObject var homeCoordinator: HWHomeCoordinator = HWHomeCoordinator()
    
    var body: some View {
        NavigationStack(path: self.$homeCoordinator.path) {
            self.homeCoordinator.build(.home)
                .navigationDestination(for: HWHomeScreen.self) { screen in
                    self.homeCoordinator.build(screen)
                        .environmentObject(self.homeCoordinator)
                }
        }
        .environmentObject(self.homeCoordinator)
    }
}

#Preview {
    HWHomeCoordinatorView()
}
