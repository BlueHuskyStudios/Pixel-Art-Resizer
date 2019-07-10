//
//  ScaledImagePreviewView.swift
//  Pixel Art Resizer 2
//
//  Created by Ben Leggiero on 2019-07-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import PixelArtKit



struct ScaledImagePreviewView : View {
    
    @State var image: UIImage
    @State var scale: Scale2D<Length> = .unscaled
    @State var margin: EdgeInsets = 48
    
    var interpolation: Image.Interpolation = .none
    
    var body: some View {
        GeometryReader { parentGeometry in
            ZStack(alignment: Alignment.center) {
                GridBackgroundView(spacing: self.imageSize(within: parentGeometry.size),
                                   scale: self.scale.inverted,
                                   origin: self.imageOrigin(within: parentGeometry.size))
                Image(uiImage: self.image)
                    .antialiased(self.interpolation.impliesAntialiasing)
                    .interpolation(self.interpolation)
                    //                .fixedSize()
                    .resizable(resizingMode: .stretch)
//                    .relativeSize(self.relativeImageSize(within: parentGeometry.size))
//                    .relativeSize(width: 0.1, height: 0.1)
                    .frame(size: self.imageSize(within: parentGeometry.size), alignment: .center)
                    .fixedSize()
//                    .frame(width: 100
//                        , height: 100
//                        self.image.size.fitted(within: parentGeometry.size, margin: 48),
//                           , alignment: Alignment.center
//                )
                    .shadow(radius: 10, y: 4)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    
    private func imageSize(within parentSize: CGSize) -> CGSize {
        print(parentSize)
        return image.size.fitted(within: parentSize, margin: margin)
    }
    
    
//    private func relativeImageSize(within parentSize: CGSize) -> CGSize {
//        return imageSize(within: parentSize) / parentSize.smallestDimension
//    }
    
    
    private func imageOrigin(within parentSize: CGSize) -> CGPoint {
        return imageSize(within: parentSize).centered(within: parentSize).origin
    }
}

#if DEBUG
struct ScaledImagePreviewView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ScaledImagePreviewView(image: .dontLoseYourWay)
                .colorScheme(.dark)
            
            ScaledImagePreviewView(image: .dontLoseYourWay, scale: 4)
                .colorScheme(.light)
        }
    }
}
#endif
