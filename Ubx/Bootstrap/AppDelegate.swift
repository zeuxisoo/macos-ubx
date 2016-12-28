//
//  AppDelegate.swift
//  Ubx
//
//  Created by Zeuxis on 7/12/2016.
//  Copyright © 2016 Zeuxis. All rights reserved.
//

import Cocoa
import MASPreferences

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    lazy var preferencesWindowController: MASPreferencesWindowController = {
        let generalPreferenceViewController = GeneralPreferenceViewController()
        let mailgunPreferenceViewController = MailgunPreferenceViewController()
        
        return MASPreferencesWindowController(
            viewControllers: [
                generalPreferenceViewController,
                mailgunPreferenceViewController
            ],
            title: NSLocalizedString("Preferences", comment: "Ubx Preferences")
        )
    }()
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    // MARK: - Application lifecycle
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.enableStatusIcon()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    // MARK: - Handle interface actions
    @IBAction func onClickPreferences(_ sender: Any) {
        self.openPreferences()
    }
    
    // MARK: - Share methods for interface or controller
    private func openPreferences() {
        self.preferencesWindowController.showWindow(nil)
    }
    
    private func enableStatusIcon() {
        // Create menu
        let menu = NSMenu()
        
        // Add menu item
        menu.addItem(NSMenuItem(title: "Show", action: #selector(self.activateApplication), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(self.quitApplication), keyEquivalent: "q"))
        
        // Set menu for menu icon
        self.statusItem.menu = menu

        // Set menu icon
        if let button = self.statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.toolTip = "Ubx"
        }
    }
    
    // MARK: - Menu item methods
    func activateApplication() {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func quitApplication() {
        NSApp.terminate(self)
    }
    
}

