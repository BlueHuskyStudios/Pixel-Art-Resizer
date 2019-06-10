//
//  GridBackgroundView.swift
//  Pixel Art Resizer
//
//  Created by Ben Leggiero on 6/9/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import UIKit



struct GridBackgroundView : View {
    
    @State var horizontalSpacing: CGFloat = 48
    @State var verticalSpacing: CGFloat = 48
    // TODO: @State var anchor: Anchor<CGPoint>.Source = .center
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
//                Rectangle()
//                    .path(in: geometry.frame(in: .local))
//                    .fill()
//                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                
                Path { path in
                    let numberOfVerticalGridLines = Int(geometry.size.width / self.verticalSpacing)
                    let numberOfHorizontalGridLines = Int(geometry.size.height / self.horizontalSpacing)
                    for index in 0...numberOfVerticalGridLines {
                        let vOffset: CGFloat = CGFloat(index) * self.verticalSpacing
                        path.move(to: CGPoint(x: vOffset, y:0))
                        path.addLine(to: CGPoint(x: vOffset, y: geometry.size.height))
                    }
                    for index in 0...numberOfHorizontalGridLines {
                        let hOffset: CGFloat = CGFloat(index) * self.horizontalSpacing
                        path.move(to: CGPoint(x: 0, y:hOffset))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: hOffset))
                    }
                }
                .stroke()
            }
        }
            .background(Color(UIColor.secondarySystemBackground))
            .foregroundColor(Color(UIColor.quaternaryLabel))
    }
}

#if DEBUG
struct GridBackgroundView_Previews : PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases) { colorScheme in
            GridBackgroundView().colorScheme(colorScheme)
        }
    }
}
#endif

extension Color {
    init(_ uiColor: UIColor) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0.8
        var brightness: CGFloat = 0.5
        var alpha: CGFloat = 1
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        self.init(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness), opacity: Double(alpha))
    }
}
