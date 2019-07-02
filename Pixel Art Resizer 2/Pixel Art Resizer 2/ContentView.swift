//
//  ContentView.swift
//  Pixel Art Resizer 2
//
//  Created by Ben Leggiero on 2019-07-01.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        VStack {
            Text("Top Placeholder")
            Spacer()
            Text("Bottom Placeholder")
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
