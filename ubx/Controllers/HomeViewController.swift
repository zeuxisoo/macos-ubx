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
    
    var events = [
        Event(name: "Test1", date: "Date1", status: "Status1"),
        Event(name: "Test2", date: "Date2", status: "Status2"),
        Event(name: "Test3", date: "Date3", status: "Status3"),
        Event(name: "Test4", date: "Date4", status: "Status4"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventListTableView.delegate = self
        self.eventListTableView.dataSource = self
    }
    
    override func viewDidAppear() {
        self.eventListTableView.reloadData()
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    // Handle interface action
    @IBAction func OnClickQueryButton(_ sender: NSButton) {
        let auth            = Service.sharedInstance.fetchAuth()
        let performanceList = Service.sharedInstance.fetchPerformanceList(eventId: 30924, pageNo: 1)
        
        when(fulfilled: auth, performanceList).then { cookie, performance -> Void in
            debugPrint(cookie)
            debugPrint(performance)

            debugPrint("performances: \(performance.performances)")
            debugPrint("performances count: \(performance.performances?.count)")
            debugPrint("status: \(performance.status?.count)")
        }.catch { error in
            let alert = NSAlert()
            
            alert.addButton(withTitle: "OK")
            alert.messageText = "Oops"
            alert.informativeText = "Cannot make query the event list\n\(error)"
            alert.alertStyle = NSAlertStyle.warning
            
            alert.runModal()
        }
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
