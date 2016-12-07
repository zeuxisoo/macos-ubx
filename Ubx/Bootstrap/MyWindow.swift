//
//  MyWindow.swift
//  Ubx
//
//  Created by Zeuxis on 7/12/2016.
//  Copyright © 2016 Zeuxis. All rights reserved.
//

import Cocoa

class MyWindow: NSWindow {
    
    // Disable title bar popup menu
    override class func standardWindowButton(_ b: NSWindowButton, for styleMask: NSWindowStyleMask) -> NSButton? {
        if b == NSWindowButton.documentVersionsButton {
            return nil
        }
        
        return super.standardWindowButton(b, for: styleMask)
    }
    
}
