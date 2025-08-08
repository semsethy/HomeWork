//
//  HWScrollOffsetPreferenceKey.swift
//  HomeWork
//
//  Created by JoshipTy on 2/8/25.
//

import SwiftUI

/// Defines a PreferenceKey for tracking the offset of a ScrollView.
/// 定義 ScrollView 偏移量的 PreferenceKey。
struct MCScrollOffsetPreferenceKey: PreferenceKey {

    /// Type of the offset value.
    /// 偏移量的類型。
    typealias Value = CGFloat

    /// Default value for the offset.
    /// 偏移量的預設值。
    static var defaultValue: CGFloat = 0

    /// Combines the values of the offset.
    /// 合併偏移量的值。
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
