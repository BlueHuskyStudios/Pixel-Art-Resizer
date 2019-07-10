//
//  Image Constants.swift
//  Pixel Art Resizer 2
//
//  Created by Ben Leggiero on 2019-07-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI



public extension UIImage {
    static var noSelectedImagePlaceholder: UIImage { UIImage(named: "No selected image placeholder")! } // ! This is bundled into our app. If this is missing, that is a developer error and so a crash here will help them find it
}



#if DEBUG
internal extension UIImage {
    static var pixelArtResizerLogo_9x9: UIImage { UIImage(named: "Pixel Art Resizer log (9x9)")! } // ! This should always be present in our dev eenvironment
    static var dontLoseYourWay: UIImage { UIImage(named: "Don't Lose Your Way")! } // ! This should always be present in our dev eenvironment
    static var foreverWithYourSoul: UIImage { UIImage(named: "Forever With Your Soul")! } // ! This should always be present in our dev eenvironment
}
#endif
