//
//  Settings.swift
//  Ubx
//
//  Created by Zeuxis on 15/12/2016.
//  Copyright © 2016 Zeuxis. All rights reserved.
//

import Foundation

class Settings {
    
    // MARK: - Class variable
    static let sharedInstance = Settings()

    private let defaults: UserDefaults? = {
        return UserDefaults.standard
    }()
    
    // MARK: - Class methods
    private func set(name: String, value: Any?) {
        self.defaults?.set(value, forKey: name)
        self.defaults?.synchronize()
    }
    
    private func get(name: String) -> Any? {
        if let returnValue = self.defaults?.object(forKey: name) {
            return returnValue as Any?
        }
        
        return nil
    }
    
    // MARK: - Setting Options
    var fetchPageNo: Int {
        set { self.set(name: "fetch_page_no", value: newValue) }
        get { return self.get(name: "fetch_page_no") as? Int ?? 1 }
    }
    
    var fetchEachPageRecord: Int {
        set { self.set(name: "fetch_each_page_record", value: newValue) }
        get { return self.get(name: "fetch_each_page_record") as? Int ?? 10 }
    }
    
    var userAgents: [String] {
        set { self.set(name: "user_agents", value: newValue) }
        get { return self.get(name: "user_agents") as? [String] ?? [] }
    }
    
}
