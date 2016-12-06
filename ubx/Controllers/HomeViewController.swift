//
//  ViewController.swift
//  ubx
//
//  Created by Zeuxis on 28/11/2016.
//  Copyright © 2016 Zeuxis. All rights reserved.
//

import Cocoa
import PromiseKit

class HomeViewController: NSViewController {
    
    @IBOutlet weak var eventListTableView: NSTableView!
    @IBOutlet weak var queryButton: NSButton!
    @IBOutlet weak var eventIdTextField: NSTextField!
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventListTableView.delegate = self
        self.eventListTableView.dataSource = self
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    // MARK: - Handle interface actions
    @IBAction func OnClickQueryButton(_ sender: NSButton) {
        let eventId = self.eventIdTextField.stringValue
        
        if eventId.isEmpty {
            self.showAlert(message: "Please enter event id")
        }else if self.isNumber(eventId) == false {
            self.showAlert(message: "Invalid format in event id")
        }else{
            let auth            = Service.sharedInstance.fetchAuth()
            let performanceList = Service.sharedInstance.fetchPerformanceList(eventId: Int(eventId)!, pageNo: 1)
            
            self.disableQueryButton()
            
            when(fulfilled: auth, performanceList).then { cookie, performanceData -> Void in
                if let performances = performanceData.performances, let status = performanceData.status {
                    // Clear all events data first
                    self.events.removeAll()
                    
                    // Add each event into events data
                    for (i, performance) in performances.enumerated() {
                        self.events.append(
                            Event(
                                name  : performance.performanceName!,
                                date  : Service.sharedInstance.formatDate(timestamp: performance.performanceDateTime!),
                                status: status[i]
                            )
                        )
                    }
                    
                    // Reload all data in event list table view
                    self.eventListTableView.reloadData()
                }
                
                self.resetQueryButton()
            }.catch { error in
                self.showAlert(
                    message: "Cannot make query for the event list",
                    callback: { response in
                        if response == NSAlertFirstButtonReturn {
                            debugPrint("OK was clicked")
                        }else{
                            debugPrint("OK not clicked")
                        }
                        
                        self.resetQueryButton()
                    }
                )
            }
        }
    }
    
    // MARK: - Share methods for interface or controller
    private func disableQueryButton() {
        self.queryButton.title = "Loading"
        self.queryButton.isEnabled = false
    }
    
    private func resetQueryButton() {
        self.queryButton.title = "Query"
        self.queryButton.isEnabled = true
    }
    
    private func isNumber(_ text: String) -> Bool {
        let numberCharSet = NSCharacterSet.decimalDigits.inverted
        
        // No empty and cannot found number at any position in text
        return text.isEmpty == false && text.rangeOfCharacter(from: numberCharSet) == nil
    }
    
    private func showAlert(message: String, callback: ((NSModalResponse) -> Void)? = nil) {
        let alert = NSAlert()
        
        alert.messageText = "Oops"
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .warning
        alert.beginSheetModal(for: self.view.window!, completionHandler: callback)
    }

}

// Control table view
extension HomeViewController: NSTableViewDelegate {
    
    // Handle cell view ui 
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let event    = self.events[row]
        let cellView = tableView.make(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        
        if tableColumn?.identifier == "ConcertName" {
            cellView.textField?.stringValue = event.name
        }
        
        if tableColumn?.identifier == "ConcertDate" {
            cellView.textField?.stringValue = event.date
        }
        
        if tableColumn?.identifier == "ConcertStatus" {
            cellView.textField?.stringValue = event.status
        }
        
        return cellView
    }
    
}

// Provide cell data
extension HomeViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.events.count
    }
    
}
