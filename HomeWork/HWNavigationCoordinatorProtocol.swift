//
//  HWNavigationCoordinatorProtocol.swift
//  HomeWork
//
//  Created by JoshipTy on 2/8/25.
//

import SwiftUI

protocol HWNavigationCoordinatorProtocol: ObservableObject {
    /// The enum representing navigable screens
    /// 表示可導航畫面的列舉型別
    associatedtype HWScreen: Hashable
    /// The enum representing sheet presentations
    /// 表示 sheet 呈現的列舉型別
    associatedtype HWSheet: Identifiable
    /// The enum representing full screen cover presentations
    /// 表示全螢幕呈現的列舉型別
//    associatedtype HWFullScreenCover: Identifiable
    
    /// Navigation path stack
    /// 導航路徑堆疊
    var path: NavigationPath { get set }
    /// Currently presented sheet
    /// 當前呈現的 sheet
    var sheet: HWSheet? { get set }
    /// Currently presented full screen cover
    /// 當前呈現的全螢幕頁面
//    var fullScreenCover: HWFullScreenCover? { get set }
    
    /// Push a new screen onto the navigation stack
    /// 將新畫面推入導航堆疊
    func push(_ screen: HWScreen)
    /// Present a sheet modally
    /// 呈現一個 sheet 視圖
    func presentSheet(_ sheet: HWSheet)
    /// Present a full screen cover modally
    /// 將新畫面推入導航堆疊
//    func presentFullScreenCover(_ fullScreenCover: HWFullScreenCover)
    
    /// Pop the last screen from the navigation stack
    /// 從導航堆疊中移除最後一個畫面
    func pop()
    /// Pop all screens and return to root
    /// 移除所有畫面並返回根頁面
    func popToRoot()
    
    /// Dismiss the currently presented sheet
    /// 關閉當前的 sheet
    func dismissSheet()
    /// Dismiss the currently presented full screen cover
    /// 關閉當前的全螢幕頁面
    func dismissFullScreenCover()
}

extension HWNavigationCoordinatorProtocol {
    var sheet: HWSheet? {
        get { nil }
        set { }
    }
//    var fullScreenCover: HWFullScreenCover? {
//        get { nil }
//        set { }
//    }
    func pop() {
        // Default implementation: remove the last screen if possible
        if !self.path.isEmpty {
            self.path.removeLast()
        }
    }
    func popToRoot() {
        guard !self.path.isEmpty, self.path.count > 0 else {
            return
        }
        self.path.removeLast(min(self.path.count, self.path.count))
    }
    func presentSheet(_ sheet: HWSheet) {}
//    func presentFullScreenCover(_ fullScreenCover: HWFullScreenCover) {}
    func dismissSheet(){}
    func dismissFullScreenCover() {}
}

//MARK: - HWBaseSheet(Default)

/// A default implementation for base sheet enum conforming to Identifiable
enum HWBaseSheet: Identifiable {
    
    var id: String {
        ""
    }
}

extension HWBaseSheet {

}

//MARK: - HWBaseFullScreenCover(Default)

/// A default implementation for base full screen cover enum conforming to Identifiable
enum HWBaseFullScreenCover: Identifiable {
    
    var id: String {
        ""
    }
}

extension HWBaseFullScreenCover {

}
