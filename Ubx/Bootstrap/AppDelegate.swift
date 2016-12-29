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
    
    // MARK: - Application lifecycle
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        StatusBar.sharedInstance.showStatusIcon()
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
    
}

