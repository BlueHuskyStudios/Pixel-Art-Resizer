//
//  ContentView.swift
//  Pixel Art Resizer 2
//
//  Created by Ben Leggiero on 2019-07-01.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import PixelArtKit



struct ContentView : View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass
    
    @State var imageScale: Length = 1
    @State var image: UIImage = .noSelectedImagePlaceholder

    var body: some View {
//        NavigationView {
            Group {
                if horizontalSizeClass == .compact
                    && verticalSizeClass == .regular {
                    VStack {
                        imageEditingView()
                        scaledImagePreviewView()
                    }
                }
                else {
                    HStack {
                        imageEditingView()
                        scaledImagePreviewView()
                    }
                }
            }
            .also {
                print(horizontalSizeClass!, verticalSizeClass!)
            }
            .relativeSize(width: 1, height: 1)
//        }
    }
    
    
    private func imageEditingView() -> some View {
        ImageEditingView(imageScale: $imageScale)
            .relativeSize(width: 1, height: 1)
    }
    
    
    private func scaledImagePreviewView() -> some View {
        ScaledImagePreviewView(image: image,
                               scale: .init(proportional: imageScale))
            .relativeSize(width: 1, height: 1)
    }
}



extension Group: HasAlso {}



#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .colorScheme(.dark)
            ContentView(imageScale: 4.5)
                .colorScheme(.light)
        }
    }
}
#endif
