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
       
    var statusItem: NSStatusItem?
    
    // MARK: - Menu controls
    func showStatusIcon() {
        // Get status item place
        self.statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        
        // Create menu items
        let showMenuItem = NSMenuItem()
        showMenuItem.title = "Show"
        showMenuItem.keyEquivalent = ""
        showMenuItem.action = #selector(activateApplication)
        showMenuItem.target = self
        
        let monitMenuItem = NSMenuItem()
        monitMenuItem.title = "Monit"
        monitMenuItem.keyEquivalent = ""
        monitMenuItem.action = #selector(monitHandler)
        monitMenuItem.target = self
        
        let quitMenuItem = NSMenuItem()
        quitMenuItem.title = "Quit"
        quitMenuItem.keyEquivalent = "q"
        quitMenuItem.action = #selector(quitApplication)
        quitMenuItem.target = self
        
        // Create menu
        let menu = NSMenu()
        menu.addItem(showMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(monitMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quitMenuItem)
        
        // Set menu into menu icon
        self.statusItem!.menu = menu
        
        // Setup menu icon
        if let button = self.statusItem!.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.toolTip = "Ubx"
        }
        
        // Observer monit event (start / stop) sent from HomeViewController
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(monitStart),
            name: NotificationName.App.DidMonitStart,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(monitStop),
            name: NotificationName.App.DidMonitStop,
            object: nil
        )
    }
    
    func hideStatusIcon() {
        NSStatusBar.system().removeStatusItem(self.statusItem!)
        
        // Remove observer
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Menu item methods
    func activateApplication() {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func quitApplication() {
        NSApp.terminate(self)
    }
    
    func monitHandler() {
        let monitMenuItem = self.statusItem!.menu!.item(withTitle: "Monit") ?? self.statusItem!.menu!.item(withTitle: "Stop")
        
        switch monitMenuItem!.title {
            case "Monit":
                NotificationCenter.default.post(
                    name: NotificationName.App.DidClickOnMenuItemMonit,
                    object: nil
                )
            case "Stop":
                NotificationCenter.default.post(
                    name: NotificationName.App.DidClickOnMenuItemStop,
                    object: nil
                )
            default:
                break
        }
    }
    
    // MARK: - Observer action handlers
    func monitStart() {
        self.statusItem!.menu!.item(withTitle: "Monit")?.title = "Stop"
    }
    
    func monitStop() {
        self.statusItem!.menu!.item(withTitle: "Stop")?.title = "Monit"
    }
    
}
