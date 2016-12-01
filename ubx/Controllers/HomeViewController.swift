//
//  ViewController.swift
//  ubx
//
//  Created by Zeuxis on 28/11/2016.
//  Copyright © 2016 Zeuxis. All rights reserved.
//

import Cocoa

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
    }
    
    override func viewDidAppear() {
        self.eventListTableView.reloadData()
    }

    override var representedObject: Any? {
        didSet {
        }
    }

}

extension HomeViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return self.events[row]
    }
    
}
