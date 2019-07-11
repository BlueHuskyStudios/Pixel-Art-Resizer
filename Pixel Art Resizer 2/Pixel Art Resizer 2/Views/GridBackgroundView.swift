//
//  GridBackgroundView.swift
//  Pixel Art Resizer 2
//
//  Created by Ben Leggiero on 2019-07-02.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import UIKit
import PixelArtKit



struct GridBackgroundView : View {
    
    var spacing: CGSize
    
    var backgroundColor = Color.gridBackground
    var foregroundColor = Color.gridLines
    
    var scale: Scale2D<Length>
    
    var origin: CGPoint = .zero
    
    
    private var horizontalSpacing: Length { spacing.width }
    private var verticalSpacing: Length { spacing.height }
    
    private var scaledHorizontalSpacing: Length { self.horizontalSpacing * scale.x }
    private var scaledVerticalSpacing: Length { self.verticalSpacing * scale.y }
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let scaledHorizontalSpacing = self.scaledHorizontalSpacing
                let scaledVerticalSpacing = self.scaledVerticalSpacing
                
                let numberOfVerticalGridLines = Int(geometry.size.width / scaledHorizontalSpacing)
                
                for index in 0...numberOfVerticalGridLines {
                    let vOffset = (Length(index) * scaledHorizontalSpacing)
                        + (self.origin.x.truncatingRemainder(dividingBy: scaledHorizontalSpacing))
                    path.move(to: CGPoint(x: vOffset, y: 0))
                    path.addLine(to: CGPoint(x: vOffset, y: geometry.size.height))
                }
                
                
                let numberOfHorizontalGridLines = Int(geometry.size.height / scaledVerticalSpacing)
                
                for index in 0...numberOfHorizontalGridLines {
                    let hOffset: Length = Length(index) * scaledVerticalSpacing
                        + (self.origin.y.truncatingRemainder(dividingBy: scaledVerticalSpacing))
                    path.move(to: CGPoint(x: 0, y: hOffset))
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
            GridBackgroundView(spacing: 48 * 48, scale: 1).colorScheme(.dark)
            GridBackgroundView(spacing: 48 * 48, scale: 1).colorScheme(.light)
            GridBackgroundView(spacing: 48 * 48, scale: 1.5, origin: CGPoint(x: 20, y: 50)).colorScheme(.dark)
        }
    }
}
#endif
