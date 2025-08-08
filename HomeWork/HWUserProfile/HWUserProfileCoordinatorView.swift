//
//  HWUserProfileCoordinatorView.swift
//  HomeWork
//
//  Created by JoshipTy on 3/8/25.
//

import SwiftUI

struct HWUserProfileCoordinatorView: View {
    
    @StateObject var userProfileCoordinator: HWUserProfileCoordinator
    
    init(path: Binding<NavigationPath>) {
        self._userProfileCoordinator = StateObject(wrappedValue: HWUserProfileCoordinator(path: path))
    }
    
    var body: some View {
        self.userProfileCoordinator.build(.home)
            .navigationDestination(for: HWUserProfileScreen.self) { screen in
                self.userProfileCoordinator.build(screen)
                    .environmentObject(self.userProfileCoordinator)
            }
            .environmentObject(self.userProfileCoordinator)
    }
}

#Preview {
    HWUserProfileCoordinatorView(path: .constant(NavigationPath()))
}
