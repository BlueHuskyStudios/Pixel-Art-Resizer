//
//  ContentView.swift
//  Pixel Art Resizer
//
//  Created by Ben Leggiero on 6/9/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        
//        GeometryReader { geometry in
            VStack {
                Spacer()
                ScaledImagePreviewView()
            }
//        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ForEach(PreviewDevice.allCases) { previewDevice in
            ForEach(ColorScheme.allCases) { colorScheme in
                ContentView().previewDevice(previewDevice).colorScheme(colorScheme)
            }
        }
    }
}
#endif



extension ColorScheme: CaseIterable {
    public static let allCases: [ColorScheme] = [.light, .dark]
}



extension ColorScheme: Identifiable {
    
    public var id: ObjectIdentifier {
        return ObjectIdentifier(NSString(string: "\(self.hashValue)"))
    }
}



extension PreviewDevice {
    static let mac: PreviewDevice = "Mac"
}



extension PreviewDevice {
    static let iPhone_7: PreviewDevice = "iPhone 7"
    static let iPhone_7_Plus: PreviewDevice = "iPhone 7 Plus"
    static let iPhone_8: PreviewDevice = "iPhone 8"
    static let iPhone_8_Plus: PreviewDevice = "iPhone 8 Plus"
    static let iPhone_SE: PreviewDevice = "iPhone SE"
    static let iPhone_X: PreviewDevice = "iPhone X"
    static let iPhone_Xs: PreviewDevice = "iPhone Xs"
    static let iPhone_Xs_Max: PreviewDevice = "iPhone Xs Max"
    static let iPhone_Xʀ: PreviewDevice = "iPhone Xʀ"
    static let iPad_mini_4: PreviewDevice = "iPad mini 4"
    static let iPad_Air_2: PreviewDevice = "iPad Air 2"
    static let iPad_Pro_9_7_inch: PreviewDevice = "iPad Pro (9.7-inch)"
    static let iPad_Pro_12_9_inch: PreviewDevice = "iPad Pro (12.9-inch)"
    static let iPad_5th_generation: PreviewDevice = "iPad (5th generation)"
    static let iPad_Pro_12_9_inch_2nd_generation: PreviewDevice = "iPad Pro (12.9-inch) (2nd generation)"
    static let iPad_Pro_10_5_inch: PreviewDevice = "iPad Pro (10.5-inch)"
    static let iPad_6th_generation: PreviewDevice = "iPad (6th generation)"
    static let iPad_Pro_11_inch: PreviewDevice = "iPad Pro (11-inch)"
    static let iPad_Pro_12_9_inch_3rd_generation: PreviewDevice = "iPad Pro (12.9-inch) (3rd generation)"
    static let iPad_mini_5th_generation: PreviewDevice = "iPad mini (5th generation)"
    static let iPad Air (3rd generation: PreviewDevice = "iPad Air (3rd generation)"
}



extension PreviewDevice: CaseIterable {
    public static var allCases: [PreviewDevice] = [
        .mac
    ]
}



extension PreviewDevice: Identifiable {
    public var id: ObjectIdentifier {
        return ObjectIdentifier(self.rawValue as NSString)
    }
}
