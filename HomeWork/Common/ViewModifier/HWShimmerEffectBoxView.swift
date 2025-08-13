//
//  HWSkimmerEffectBoxView.swift
//  HomeWork
//
//  Created by JoshipTy on 9/8/25.
//

import SwiftUI

struct HWShimmerEffectBoxView: View {
    private var gradientColor = [
        Color(uiColor: UIColor.systemGray5),
        Color(uiColor: UIColor.systemGray6),
        Color(uiColor: UIColor.systemGray5)
    ]
    @State var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
    @State var endPoint: UnitPoint = .init(x: 0, y: -0.2)
    var body: some View {
        LinearGradient(colors: gradientColor, startPoint: startPoint, endPoint: endPoint)
            .onAppear{
                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false)){
                    self.startPoint = .init(x: 1, y: 1)
                    self.endPoint = .init(x: 2.2, y: 2.2)
                }
            }
    }
}
