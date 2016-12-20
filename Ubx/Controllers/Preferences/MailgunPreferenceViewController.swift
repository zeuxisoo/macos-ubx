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

    @IBOutlet weak var mailgunDomainTextField: NSTextField!
    @IBOutlet weak var mailgunApiKeyTextField: NSTextField!
    @IBOutlet weak var mailgunEnableCheckbox: NSButton!
    
    @IBOutlet weak var mailboxFromTextField: NSTextField!
    @IBOutlet weak var mailboxToTextField: NSTextField!
    @IBOutlet weak var mailboxSubjectTextField: NSTextField!
    
    typealias ValidateAllTextFieldSuccess = (_ domain: String, _ apiKey: String, _ from: String, _ to: String, _ subject: String) -> Void
    
    var settings = Settings.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mailgunDomainTextField.delegate  = self
        self.mailgunApiKeyTextField.delegate  = self
        self.mailboxFromTextField.delegate    = self
        self.mailboxToTextField.delegate      = self
        self.mailboxSubjectTextField.delegate = self
        
        self.mailgunDomainTextField.stringValue  = self.settings.mailgunDomain
        self.mailgunApiKeyTextField.stringValue  = self.settings.mailgunApiKey
        self.mailboxFromTextField.stringValue    = self.settings.mailboxFrom
        self.mailboxToTextField.stringValue      = self.settings.mailboxTo
        self.mailboxSubjectTextField.stringValue = self.settings.mailboxSubject
        
        self.mailgunEnableCheckbox.state = self.settings.mailgunEnable ? NSOnState : NSOffState
    }
    
    override func viewDidDisappear() {
        self.saveAllSettings()
    }
    
    // MARK: - Handle interface action
    @IBAction func onClickMailgunTestButton(_ sender: Any) {
        self.validateAllTextField { (domain, apiKey, from, to, subject) in
            Service.sharedInstance.sendMail(
                domain: domain,
                apiKey: apiKey,
                from: from,
                to: to,
                subject: subject,
                success: { (id, message) in
                    if id.isEmpty == false && message.isEmpty == false {
                        self.showAlert(message: "Success! Mail sent")
                        self.saveAllTextField()
                    }
                },
                failure: { error in
                    self.showAlert(message: "Error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    @IBAction func onClickMailgunEnableCheckbox(_ sender: Any) {
        if let enableCheckbox = sender as? NSButton {
            self.validateAllTextField(
                success: { (domain, apiKey, from, to, subject) in
                    self.saveAllSettings()
                },
                failure: {
                    enableCheckbox.state = NSOffState
                }
            )
        }
    }
    
    // MARK: - Share methods for interface
    private func showAlert(message: String) {
        let alert = NSAlert()
        
        alert.informativeText = message
        alert.messageText = "Oops"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = .informational
        alert.beginSheetModal(for: self.view.window!) { modalResponse in
            if modalResponse == NSAlertFirstButtonReturn {
            }
        }
    }
    
    private func validateAllTextField(success: ValidateAllTextFieldSuccess) {
        self.validateAllTextField(success: success, failure: {})
    }
    
    private func validateAllTextField(success: ValidateAllTextFieldSuccess, failure: () -> Void) {
        let domain  = self.mailgunDomainTextField.stringValue
        let apiKey  = self.mailgunApiKeyTextField.stringValue
        let from    = self.mailboxFromTextField.stringValue
        let to      = self.mailboxToTextField.stringValue
        let subject = self.mailboxSubjectTextField.stringValue
        
        if domain.isEmpty == true {
            self.showAlert(message: "Please enter mailgun domain")
            failure()
        }else if apiKey.isEmpty == true {
            self.showAlert(message: "Please enter mailgun api key")
            failure()
        }else if from.isEmpty == true {
            self.showAlert(message: "Please enter from address for mailbox")
            failure()
        }else if to.isEmpty == true {
            self.showAlert(message: "Please enter to address for mailbox")
            failure()
        }else if subject.isEmpty == true {
            self.showAlert(message: "Please enter subject for mailbox")
            failure()
        }else{
            success(domain, apiKey, from, to, subject)
        }
    }
    
    private func saveAllTextField() {
        self.settings.mailgunDomain  = self.mailgunDomainTextField.stringValue
        self.settings.mailgunApiKey  = self.mailgunApiKeyTextField.stringValue
        self.settings.mailboxFrom    = self.mailboxFromTextField.stringValue
        self.settings.mailboxTo      = self.mailboxToTextField.stringValue
        self.settings.mailboxSubject = self.mailboxSubjectTextField.stringValue
    }
    
    private func saveAllSettings() {
        self.saveAllTextField()
        
        self.settings.mailgunEnable = self.mailgunEnableCheckbox.state == NSOnState
    }

}

// MARK: - Implement NS
extension MailgunPreferenceViewController: NSTextFieldDelegate {
    
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        let textField = control as! NSTextField
        let identifier = textField.identifier!
        
        if identifier == "MailgunDomain" {
            self.settings.mailgunDomain = fieldEditor.string!
        }
        
        if identifier == "MailgunApiKey" {
            self.settings.mailgunApiKey = fieldEditor.string!
        }

        if identifier == "MailboxFrom" {
            self.settings.mailboxFrom = fieldEditor.string!
        }

        if identifier == "MailboxTo" {
            self.settings.mailboxTo = fieldEditor.string!
        }

        if identifier == "MailboxSubject" {
            self.settings.mailboxSubject = fieldEditor.string!
        }
        
        return true
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
