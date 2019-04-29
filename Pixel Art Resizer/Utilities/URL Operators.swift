//
//  URL Operators.swift
//  Pixel Art Resizer
//
//  Created by Ben Leggiero on 4/28/19.
//  Copyright © 2019 Blue Husky Studios BH-1-PS
//

import Foundation



public extension URL {
    
    static func / (original: URL, filename: String) -> URL {
        return original.appendingPathComponent(filename)
    }
    
    
    static func /= (original: inout URL, filename: String) {
        original.appendPathComponent(filename)
    }
}
