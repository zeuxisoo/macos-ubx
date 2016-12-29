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
    @IBOutlet weak var userAgentsTableView: NSTableView!
    @IBOutlet weak var userInterfaceDisplayMenuBarIcon: NSButton!
    
    let settings = Settings.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the user interface
        self.userInterfaceDisplayMenuBarIcon.state = self.settings.userInterfaceDisplayMenuBarIcon ? NSOnState : NSOffState
        
        // Set the default value to 2 fetch combo boxes
        self.fetchPageNoComboBox.cell?.title = String(self.settings.fetchPageNo)
        self.fetchEachPageRecordComboBox.cell?.title = String(self.settings.fetchEachPageRecord)
        
        // Delegate 2 fetch combo boxes
        self.fetchPageNoComboBox.delegate = self
        self.fetchEachPageRecordComboBox.delegate = self
        
        // Delegate user agents table view and data source
        self.userAgentsTableView.delegate = self
        self.userAgentsTableView.dataSource = self
    }
    
    // MARK: - Control interface action
    @IBAction func onClickUserAgentsAddButton(_ sender: Any) {
        // Create input text field
        let input = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        
        input.stringValue = ""
        input.placeholderString = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36"
        input.translatesAutoresizingMaskIntoConstraints = true
        input.lineBreakMode = .byClipping
        input.cell?.isScrollable = true
        
        // Create alert dialog to ask user agent string
        let alert = NSAlert()
        
        alert.messageText = "Add user agent"
        alert.informativeText = "Please enter here:"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.accessoryView = input
        
        alert.beginSheetModal(for: self.view.window!) { modalResponse in
            if modalResponse == NSAlertFirstButtonReturn {
                var userAgents = self.settings.userAgents
                let userAgent  = input.stringValue
                
                if userAgent.isEmpty == false {
                    userAgents.append(userAgent)
                    
                    self.settings.userAgents = userAgents
                    
                    self.userAgentsTableView.reloadData()
                    self.userAgentsTableView.scrollRowToVisible(userAgents.count - 1)
                }
            }
        }
    }
    
    @IBAction func onClickUserAgentsRemoveButton(_ sender: Any) {
        var newUserAgents = [String]()
        
        for (index, agent) in self.settings.userAgents.enumerated() {
            if self.userAgentsTableView.isRowSelected(index) == false {
                newUserAgents.append(agent)
            }
        }

        self.settings.userAgents = newUserAgents
        self.userAgentsTableView.reloadData()
    }
    
    @IBAction func onClickUserInterfaceDisplayMenuBarIconCheckbox(_ sender: Any) {
        self.settings.userInterfaceDisplayMenuBarIcon = !self.settings.userInterfaceDisplayMenuBarIcon
        debugPrint((sender as! NSButton).state)
        debugPrint(self.settings.userInterfaceDisplayMenuBarIcon)
        if (sender as! NSButton).state == NSOnState {
            StatusBar.sharedInstance.showStatusIcon()
        }else{
            StatusBar.sharedInstance.hideStatusIcon()
        }
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

// MARK: - Implement NSTableView delegate and data source methods
extension GeneralPreferenceViewController: NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.settings.userAgents.count
    }
    
}

extension GeneralPreferenceViewController: NSTableViewDataSource {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let userAgent = self.settings.userAgents[row]
        let cellView  = tableView.make(withIdentifier: (tableColumn?.identifier)!, owner: nil) as! NSTableCellView
        
        if tableColumn?.identifier == "UserAgent" {
            cellView.textField?.stringValue = userAgent
        }
        
        return cellView
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
