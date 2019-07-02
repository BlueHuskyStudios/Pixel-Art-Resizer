//
//  GridBackgroundView.swift
//  Pixel Art Resizer 2
//
//  Created by Ben Leggiero on 2019-07-02.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import UIKit



struct GridBackgroundView : View {
    
    @State var horizontalSpacing: CGFloat = 48
    @State var verticalSpacing: CGFloat = 48
    
    @State var backgroundColor: Color = Color.primary
    @State var foregroundColor: Color = Color.secondary
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let numberOfHorizontalGridLines = Int(geometry.size.height / self.horizontalSpacing)
                let numberOfVerticalGridLines = Int(geometry.size.width / self.verticalSpacing)
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
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
    }
}

#if DEBUG
struct GridBackgroundView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            GridBackgroundView().colorScheme(.dark)
            GridBackgroundView().colorScheme(.light)
        }
    }
}
#endif
