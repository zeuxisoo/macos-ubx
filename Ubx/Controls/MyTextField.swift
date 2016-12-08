//
//  MyButton.swift
//  Ubx
//
//  Created by Zeuxis on 8/12/2016.
//  Copyright © 2016 Zeuxis. All rights reserved.
//

import Cocoa

class MyTextField: NSTextField {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        self.focusRingType = .none
    }
    
}
