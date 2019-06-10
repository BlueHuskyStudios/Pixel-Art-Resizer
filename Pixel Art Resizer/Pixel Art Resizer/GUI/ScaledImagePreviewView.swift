//
//  ScaledImagePreviewView.swift
//  Pixel Art Resizer
//
//  Created by Ben Leggiero on 6/10/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI

struct ScaledImagePreviewView : View {
    
    @State var imageScale: CGFloat = 1
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image(uiImage: UIImage())
                Spacer()
            }
            Spacer()
        }
        .background(GridBackgroundView())
    }
}

#if DEBUG
struct ScaledImagePreviewView_Previews : PreviewProvider {
    static var previews: some View {
        ScaledImagePreviewView()
    }
}
#endif
