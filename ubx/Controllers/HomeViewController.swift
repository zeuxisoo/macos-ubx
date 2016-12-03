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
    
    // Handle interface action
    @IBAction func OnClickQueryButton(_ sender: NSButton) {
        let auth            = Service.sharedInstance.fetchAuth()
        let performanceList = Service.sharedInstance.fetchPerformanceList(eventId: 30924, pageNo: 1)
        
        when(fulfilled: auth, performanceList).then { cookie, performanceData -> Void in
            debugPrint(cookie)
            debugPrint(performanceData)

            debugPrint("performances: \(performanceData.performances)")
            debugPrint("performances count: \(performanceData.performances?.count)")
            debugPrint("status: \(performanceData.status?.count)")
            
            if let performances = performanceData.performances, let status = performanceData.status {
                for (i, performance) in performances.enumerated() {
                    self.events.append(
                        Event(
                            name  : performance.performanceName!,
                            date  : Service.sharedInstance.formatDate(timestamp: performance.performanceDateTime!),
                            status: status[i]
                        )
                    )
                }
                
                self.eventListTableView.reloadData()
            }
        }.catch { error in
            let alert = NSAlert()
            
            alert.messageText = "Oops"
            alert.informativeText = "Cannot make query for the event list"
            alert.addButton(withTitle: "OK")
            alert.alertStyle = .warning
            alert.beginSheetModal(for: self.view.window!, completionHandler: { response in
                if response == NSAlertFirstButtonReturn {
                    debugPrint("OK was clicked")
                }else{
                    debugPrint("OK not clicked")
                }
            })
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
