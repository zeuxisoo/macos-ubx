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
    
    @IBOutlet weak var mailboxFromTextField: NSTextField!
    @IBOutlet weak var mailboxToTextField: NSTextField!
    @IBOutlet weak var mailboxSubjectTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Handle interface action
    @IBAction func onClickMailgunTestButton(_ sender: Any) {
        let domain  = self.mailgunDomainTextField.stringValue
        let apiKey  = self.mailgunApiKeyTextField.stringValue
        let from    = self.mailboxFromTextField.stringValue
        let to      = self.mailboxToTextField.stringValue
        let subject = self.mailboxSubjectTextField.stringValue
        
        if domain.isEmpty == true {
            self.showAlert(message: "Please enter mailgun domain")
        }else if apiKey.isEmpty == true {
            self.showAlert(message: "Please enter mailgun api key")
        }else if from.isEmpty == true {
            self.showAlert(message: "Please enter from address for mailbox")
        }else if to.isEmpty == true {
            self.showAlert(message: "Please enter to address for mailbox")
        }else if subject.isEmpty == true {
            self.showAlert(message: "Please enter subject for mailbox")
        }else{
            Service.sharedInstance.sendMail(
                domain: domain,
                apiKey: apiKey,
                from: from,
                to: to,
                subject: subject,
                success: { (id, message) in
                    if id.isEmpty == false && message.isEmpty == false {
                        self.showAlert(message: "Success! Mail sent")
                    }
                },
                failure: { error in
                    self.showAlert(message: "Error: \(error.localizedDescription)")
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
