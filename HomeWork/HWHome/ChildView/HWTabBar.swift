//
//  HWTabBar.swift
//  HomeWork
//
//  Created by JoshipTy on 4/8/25.
//

import SwiftUI

enum Tab {
    case home, view1, view2, view3
}

struct HWTabBar: View {
    
    @Binding var selectedTab: Tab
    
    @State private var qrIsShown: Bool = false
    
    @State private var showFailureAlert = false

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color(UIColor(white: 1, alpha: 1)))
                .frame(height: 80)
                .cornerRadius(40)
                .shadow(radius: 6)

            HStack {
                Spacer()
                tabButton(icon: "icTabbarHomeActive", label: "Home", tab: .home)
                Spacer()
                tabButton(icon: "icTabbarAccountDefault", label: "Account", tab: .view1)
                Spacer()
                tabButton(icon: "icTabbarLocationActive", label: "Location", tab: .view2)
                Spacer()
                tabButton(icon: "icTabbarAccountDefault", label: "Service", tab: .view3)
                Spacer()
            }

        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .ignoresSafeArea(edges: .bottom)
        .background(.clear)
    }

    private func tabButton(icon: String, label: String, tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 5) {
                Image(icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.system(size: 13))
                    .fontWeight(.medium)
                    .foregroundStyle(.black)
            }
            .foregroundColor(selectedTab == tab ? .primary : .secondary)
        }
    }
}

#Preview {
    HWTabBar(selectedTab: .constant(.home))
}

struct CustomTabMainView: View {
    @State private var selectedTab: Tab = .home
 
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    NavigationView { HWHomeCoordinatorView() }
                        .tag(Tab.home)

                    NavigationView { View1() }
                        .tag(Tab.view1)
                    
                    NavigationView { View2() }
                        .tag(Tab.view2)
                    
                    NavigationView { View3() }
                        .tag(Tab.view3)
                }
                .onAppear {
                    let tabBarAppearance = UITabBarAppearance()
                    tabBarAppearance.configureWithOpaqueBackground()
                    tabBarAppearance.backgroundColor = UIColor.clear
                    tabBarAppearance.shadowColor = UIColor.clear

                    UITabBar.appearance().standardAppearance = tabBarAppearance
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                    UITabBar.appearance().unselectedItemTintColor = UIColor.gray
                }

                HWTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal, 20)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

#Preview {
    CustomTabMainView()
}
 
struct View1: View {
    var body: some View {
        
    }
}

struct View2: View {
    var body: some View {
        
    }
}

struct View3: View {
    var body: some View {
        
    }
}
