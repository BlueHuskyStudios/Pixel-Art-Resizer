//
//  ImageEditingView.swift
//  Pixel Art Resizer 2
//
//  Created by Ben Leggiero on 2019-07-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI

struct ImageEditingView : View {
    
    @State var imageScale: Binding<Length>
    
    var body: some View {
        VStack {
            Slider(value: imageScale, from: 0.1, through: 5, by: 0.1)
        }
    }
}

#if DEBUG
struct ImageEditingView_Previews : PreviewProvider {
    static var previews: some View {
        ImageEditingView(imageScale: .constant(1))
    }
}
#endif
