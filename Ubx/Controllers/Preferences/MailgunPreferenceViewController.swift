//
//  MailgunPreferenceViewController.swift
//  Ubx
//
//  Created by Zeuxis on 16/12/2016.
//  Copyright © 2016 Zeuxis. All rights reserved.
//

import Cocoa
import MASPreferences

class MailgunPreferenceViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - Implement MASPreferencesViewController protocol methods
extension MailgunPreferenceViewController: MASPreferencesViewController {
    
    override var identifier: String? {
        get {
            return "MailgunPreferences"
        }
        set {
            super.identifier = newValue
        }
    }
    
    var toolbarItemImage: NSImage! {
        return NSImage(named: "PreferencesMailgun")
    }
    
    var toolbarItemLabel: String! {
        return NSLocalizedString("Mailgun", comment: "Mailgun preference pane")
    }
    
}
