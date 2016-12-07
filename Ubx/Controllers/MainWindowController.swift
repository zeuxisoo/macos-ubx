//
//  MainWindowController.swift
//  Ubx
//
//  Created by Zeuxis on 7/12/2016.
//  Copyright © 2016 Zeuxis. All rights reserved.
//

import Foundation
import Cocoa

class MainWindowController: NSWindowController {
    
    override func windowTitle(forDocumentDisplayName displayName: String) -> String {
        return self.window!.title
    }
    
}
