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
    @IBOutlet weak var timerSecondTextField: NSTextField!
    @IBOutlet weak var monitButton: NSButton!
    
    var repeatTimer: Timer?
    
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
            self.queryEvents(
                eventId: eventId,
                beforeQueryAction: {
                    self.disableQueryButton()
                },
                afterEventListTableViewReloaded: { _ in
                    self.resetQueryButton()
                },
                failure: { _ in
                    self.showAlert(message: "Cannot make query for the event list")
                }
            )
        }
    }
    
    @IBAction func OnClickMonitButton(_ sender: Any) {
        let monitButtonTitle = self.monitButton.title
        
        switch monitButtonTitle.lowercased() {
            case "monit":
                let eventId     = self.eventIdTextField.stringValue
                let timerSecond = self.timerSecondTextField.stringValue
                
                if eventId.isEmpty {
                    self.showAlert(message: "Please enter event id")
                }else if timerSecond.isEmpty {
                    self.showAlert(message: "Please enter timer second")
                }else if self.isNumber(eventId) == false {
                    self.showAlert(message: "Invalid format in event id")
                }else if self.isNumber(timerSecond) == false {
                    self.showAlert(message: "Invalid format in timer second")
                }else if Int(timerSecond)! <= 0 {
                    self.showAlert(message: "Timer seconds must bigger than 0")
                }else{
                    self.disableAllControlWhenMonitStart()

                    self.repeatTimer = Timer(
                        timeInterval: Double(timerSecond)!,
                        repeats: true,
                        block: { timer in
                            self.queryEvents(
                                eventId: eventId,
                                beforeQueryAction: {
                                    debugPrint("Timer triggered")
                                },
                                afterEventListTableViewReloaded: { events in
                                    // Show notification when events status contain AVAILABLE
                                    if events.count > 0 {
                                        let availableEvents = events.map({ event in
                                            return event.status.uppercased() == "AVAILABLE"
                                        })
                                        
                                        if availableEvents.count > 0 {
                                            self.makeNotification(title: "Wow", message: "\(events.first!.name) is available")
                                        }
                                    }
                                },
                                failure: { error in
                                    debugPrint("- error: \(error)")
                                }
                            )
                        }
                    )
                    self.repeatTimer?.fire()
                    
                    RunLoop.main.add(self.repeatTimer!, forMode: RunLoopMode.defaultRunLoopMode)
                }
                break
            case "stop":
                self.repeatTimer?.invalidate()
                self.repeatTimer = nil
                
                self.resetAllControlWhenMonitStop()
                break
            default:
                break
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
    
    private func disableAllControlWhenMonitStart() {
        self.eventIdTextField.isEnabled = false
        self.queryButton.isEnabled = false
        
        self.timerSecondTextField.isEnabled = false
        self.monitButton.title = "Stop"
    }
    
    private func resetAllControlWhenMonitStop() {
        self.eventIdTextField.isEnabled = true
        self.queryButton.isEnabled = true
        
        self.timerSecondTextField.isEnabled = true
        self.monitButton.title = "Monit"
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
    
    private func queryEvents(eventId: String, beforeQueryAction: () -> Void, afterEventListTableViewReloaded: @escaping ([Event]) -> Void, failure: @escaping (Error) -> Void) {
        let auth            = Service.sharedInstance.fetchAuth()
        let performanceList = Service.sharedInstance.fetchPerformanceList(eventId: Int(eventId)!, pageNo: 1)
        
        beforeQueryAction()
        
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
            
            afterEventListTableViewReloaded(self.events)
        }.catch { error in
            failure(error)
        }
    }
    
    private func makeNotification(title: String, message: String) {
        let userNotification = NSUserNotification()
        
        userNotification.title = title
        userNotification.informativeText = message
        userNotification.soundName = NSUserNotificationDefaultSoundName
        
        userNotification.hasActionButton = true
        userNotification.actionButtonTitle = "View"
        
        NSUserNotificationCenter.default.deliver(userNotification)
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
