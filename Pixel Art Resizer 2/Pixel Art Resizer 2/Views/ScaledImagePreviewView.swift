//
//  ScaledImagePreviewView.swift
//  Pixel Art Resizer 2
//
//  Created by Ben Leggiero on 2019-07-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import PixelArtKit
import simd



struct ScaledImagePreviewView : View {
    
    var image: UIImage
    var scale: Scale2D<Length>
    var margin: EdgeInsets = 48
    
    var interpolation: Image.Interpolation = .none
    
    var allowedWarnings: Warnings = [.shrinking, .fractional, .unchanged]
    
    var body: some View {
        GeometryReader { parentGeometry in
            ZStack(alignment: Alignment.center) {
                GridBackgroundView(spacing: self.imageSize(within: parentGeometry.size),
                                   foregroundColor: self.gridLineColor,
                                   scale: self.scale.inverted,
                                   origin: self.imageOrigin(within: parentGeometry.size))
                    .overlay(ScaledImagePreviewView.WarningsView(warnings: self.currentWarnings),
                             alignment: .bottom)
                Image(uiImage: self.image)
                    .antialiased(self.interpolation.impliesAntialiasing)
                    .interpolation(self.interpolation)
                    .resizable(resizingMode: .stretch)
                    .frame(size: self.imageSize(within: parentGeometry.size), alignment: .center)
                    .fixedSize()
                    .shadow(radius: 10, y: 4)
            }
        }
//        .also { print(#function, scale) }
        .edgesIgnoringSafeArea(.all)
    }
    
    
    private func imageSize(within parentSize: CGSize) -> CGSize {
//        print(parentSize)
        return image.size.fitted(within: parentSize, margin: margin)
    }
    
    
//    private func relativeImageSize(within parentSize: CGSize) -> CGSize {
//        return imageSize(within: parentSize) / parentSize.smallestDimension
//    }
    
    
    private func imageOrigin(within parentSize: CGSize) -> CGPoint {
        return imageSize(within: parentSize).centered(within: parentSize).origin
    }
    
    
    private var gridLineColor: Color {
        if scale.isUnscaled() {
            return .gridLines
        }
        else if scale.isInteger() {
            return .gridLinesForGood
        }
        else {
            if currentWarnings.isEmpty {
                return .gridLines
            }
            else {
                // Some warning is showing
                return .gridLinesForWarnings
            }
        }
    }
    
    
    private var currentWarnings: Warnings {
        var currentWarnings = Warnings()
        if allowedWarnings.contains(.shrinking), isShrinking {
            currentWarnings.insert(.shrinking)
        }
        if allowedWarnings.contains(.growing), isGrowing {
            currentWarnings.insert(.growing)
        }
        if allowedWarnings.contains(.fractional), isScaledFractionally {
            currentWarnings.insert(.fractional)
        }
        if allowedWarnings.contains(.unchanged), isUnscaled {
            currentWarnings.insert(.unchanged)
        }
        return currentWarnings
    }
    
    
    private var isShrinking: Bool {
        return scale.isLessThan(.unscaled, approach: .atAll)
    }
    
    
    private var isGrowing: Bool {
        return scale.isGreaterThan(.unscaled, approach: .atAll)
    }
    
    
    private var isScaledFractionally: Bool {
        return !scale.isInteger()
    }
    
    
    private var isUnscaled: Bool {
        return scale.isUnscaled()
    }
}



#if DEBUG
struct ScaledImagePreviewView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ScaledImagePreviewView(image: .dontLoseYourWay, scale: 1)
                .colorScheme(.dark)
            
            ScaledImagePreviewView(image: .dontLoseYourWay, scale: 4)
                .colorScheme(.light)
        }
    }
}
#endif



extension GeometryReader: HasAlso {}



extension ScaledImagePreviewView {
    
    struct WarningsView: View {
        var warnings: Warnings
        
        var body: some View {
            GeometryReader { parentGeometry in
                VStack(alignment: .center, spacing: 12) {
                    Spacer()
                    ForEach(self.warnings.granules.identified(by: \.rawValue)) { warning in
                        HStack {
                            Spacer()
                            self.makeWarningText(with: warning)
                                .padding(EdgeInsets(eachVertical: 4, eachHorizontal: 12))
                                .border(Color.secondary, width: 1, cornerRadius: 8)
                                .background(Color.gridBackground)
                            Spacer()
                        }
                    }
                }
                .padding(parentGeometry.safeAreaInsets)
            }
        }
        
        
        func makeWarningText(with warning: Warning) -> Text {
            switch warning {
            case .shrinking:
                return Text("warning.scaledImagePreview.shrinking.short")
                    .color(.red)
                
            case .growing:
                return Text("warning.scaledImagePreview.growing.short")
                    .color(.yellow)
                
            case .unchanged:
                return Text("warning.scaledImagePreview.unchanged.short")
                    .color(.secondary)
                
            case .fractional:
                return Text("warning.scaledImagePreview.fractional.short")
                    .color(.yellow)
            }
        }
    }
    
    
    
    public struct Warnings: GranularOptionSet {
        public typealias Granule = Warning
        
        let rawValue: UInt8
        
        /// Warn users that the preview shows a shrinking image
        static let shrinking = Warnings(shifting: .shrinking)
        
        /// Warn users that the preview shows a growing image
        static let growing = Warnings(shifting: .growing)
        
        /// Warn users that the preview shows an unchanged image
        static let unchanged = Warnings(shifting: .unchanged)
        
        /// Warn users that the preview shows an image which is not scaled to a whole number
        static let fractional = Warnings(shifting: .fractional)
    }
    
    
    
    public enum Warning: UInt8, GranularOptionSet.GranuleProtocol {
        /// Warn users that the preview shows a shrinking image
        case shrinking = 1
        
        /// Warn users that the preview shows a growing image
        case growing = 2
        
        /// Warn users that the preview shows an unchanged image
        case unchanged = 3
        
        /// Warn users that the preview shows an image which is not scaled to a whole number
        case fractional = 4
    }
}
