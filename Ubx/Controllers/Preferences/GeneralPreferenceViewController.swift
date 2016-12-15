//
//  GeneralPreferenceViewController.swift
//  Ubx
//
//  Created by Zeuxis on 15/12/2016.
//  Copyright © 2016 Zeuxis. All rights reserved.
//

import Cocoa
import MASPreferences

class GeneralPreferenceViewController: NSViewController {
    
    @IBOutlet weak var fetchPageNoComboBox: NSComboBox!
    @IBOutlet weak var fetchEachPageRecordComboBox: NSComboBox!
    
    let settings = Settings.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchPageNoComboBox.selectItem(withObjectValue: self.settings.fetchPageNo)
        self.fetchEachPageRecordComboBox.selectItem(withObjectValue: self.settings.fetchEachPageRecord)
        
        self.fetchPageNoComboBox.delegate = self
        self.fetchEachPageRecordComboBox.delegate = self
    }

}

// MARK: - Implement  NSComboBox delegate methods
extension GeneralPreferenceViewController: NSComboBoxDelegate {
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        if let combox = notification.object as? NSComboBox {
            let currentItem = (combox.objectValueOfSelectedItem as! NSString).integerValue
            
            if combox.identifier == "FetchPageNo" {
                self.settings.fetchPageNo = currentItem
            }
            
            if combox.identifier == "FetchEachPageRecord" {
                self.settings.fetchEachPageRecord = currentItem
            }
        }
    }
    
}

// MARK: - Implement MASPreferencesViewController protocol methods
extension GeneralPreferenceViewController: MASPreferencesViewController {
    
    override var identifier: String? {
        get {
            return "GeneralPreferences"
        }
        set {
            super.identifier = newValue
        }
    }
    
    var toolbarItemImage: NSImage! {
        return NSImage(named: NSImageNamePreferencesGeneral)
    }
    
    var toolbarItemLabel: String! {
        return NSLocalizedString("General", comment: "General preference pane")
    }
    
}
