//
//  MyButtonCell.swift
//  Ubx
//
//  Created by Zeuxis on 8/12/2016.
//  Copyright © 2016 Zeuxis. All rights reserved.
//

import Cocoa

class MyButtonCell: NSButtonCell {
    
    override func drawTitle(_ title: NSAttributedString, withFrame frame: NSRect, in controlView: NSView) -> NSRect {
        // Show blue color for title when button disabled and default using green color
        let fontColor: NSColor
        
        if self.isEnabled {
            fontColor = NSColor.green
        }else{
            fontColor = NSColor(red:0.08, green:0.46, blue:0.98, alpha:1.00)
        }
        
        let colorTitle = NSMutableAttributedString(attributedString: attributedTitle)
        let titleRange = NSMakeRange(0, colorTitle.length)
        
        colorTitle.addAttribute(NSForegroundColorAttributeName, value: fontColor, range: titleRange)
        colorTitle.addAttribute(NSFontAttributeName, value: self.font!, range: titleRange)
        
        attributedTitle = colorTitle
        
        return super.drawTitle(attributedTitle, withFrame: frame, in: controlView)
    }
    
}
