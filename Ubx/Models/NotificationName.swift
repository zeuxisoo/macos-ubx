//
//  NotificationName.swift
//  Ubx
//
//  Created by Zeuxis on 30/12/2016.
//  Copyright © 2016 Zeuxis. All rights reserved.
//

import Foundation

class NotificationName {
    
    struct App {
        // MARK: - StatusBar menu item
        static let DidClickOnMenuItemMonit = Notification.Name("Ubx.App.DidClickOnMenuItemMonit")
        static let DidClickOnMenuItemStop  = Notification.Name("Ubx.App.DidClickOnMenuItemStop")
        
        // MARK: - HomeViewController
        static let DidMonitStart = Notification.Name("Ubx.App.DidMonitStart")
        static let DidMonitStop  = Notification.Name("Ubx.App.DidMonitStop")
    }
    
}
