//
//  ContentView.swift
//  Pixel Art Resizer 2
//
//  Created by Ben Leggiero on 2019-07-01.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    init() { // for navigation bar title color
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.red]
        // For navigation bar background color
//        UINavigationBar.appearance().backgroundColor = .green
    }

    var body: some View {
        NavigationView {
            VStack {
                ImageEditingView()
                    .relativeSize(width: 1, height: 1)
                ScaledImagePreviewView(image: .noSelectedImagePlaceholder)
                    .relativeSize(width: 1, height: 1)
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().colorScheme(.dark)
            ContentView().colorScheme(.light)
        }
    }
}
#endif
