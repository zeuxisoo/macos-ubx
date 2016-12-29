//
//  StatusBar.swift
//  Ubx
//
//  Created by Zeuxis on 29/12/2016.
//  Copyright © 2016 Zeuxis. All rights reserved.
//

import Cocoa

class StatusBar: NSObject {
    
    static let sharedInstance = StatusBar()
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    func showStatusIcon() {
        // Create menu items
        let showMenuItem = NSMenuItem()
        showMenuItem.title = "Show"
        showMenuItem.keyEquivalent = ""
        showMenuItem.action = #selector(activateApplication)
        showMenuItem.target = self
        
        let quitMenuItem = NSMenuItem()
        quitMenuItem.title = "Quit"
        quitMenuItem.keyEquivalent = "q"
        quitMenuItem.action = #selector(quitApplication)
        quitMenuItem.target = self
        
        // Create menu
        let menu = NSMenu()
        menu.addItem(showMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quitMenuItem)
        
        // Set menu into menu icon
        self.statusItem.menu = menu
        
        // Setup menu icon
        if let button = self.statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.toolTip = "Ubx"
        }
    }
    
    func hideStatusIcon() {
        NSStatusBar.system().removeStatusItem(statusItem)
    }
    
    // MARK: - Menu item methods
    func activateApplication() {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func quitApplication() {
        NSApp.terminate(self)
    }
    
}
