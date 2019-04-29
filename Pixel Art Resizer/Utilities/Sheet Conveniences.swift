//
//  Sheet Conveniences.swift
//  Pixel Art Resizer
//
//  Created by Ben Leggiero on 4/26/19.
//  Copyright © 2019 Blue Husky Studios BH-1-PS
//

import Cocoa



public extension NSSavePanel {
    func present(on window: NSWindow?, response: @escaping (NSApplication.ModalResponse) -> ()) {
        if let window = window {
            self.beginSheetModal(for: window, completionHandler: response)
        }
        else {
            response(self.runModal())
        }
    }
}
