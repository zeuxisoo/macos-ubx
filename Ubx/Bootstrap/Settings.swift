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
        get {
            return self.get(name: "user_agents") as? [String] ?? [
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36",
                "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fr) AppleWebKit/416.12 (KHTML, like Gecko) Safari/412.5",
                "Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120819 Firefox/15.0 PaleMoon/15.0",
                "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; GTB6; Acoo Browser; .NET CLR 1.1.4322; .NET CLR 2.0.50727)",
                "Mozilla/5.0 (Windows; U; Windows NT 5.1; pt-BR) AppleWebKit/534.12 (KHTML, like Gecko) NavscapeNavigator/Pre-0.1 Safari/534.12",
                "Mozilla/5.0 (Windows; U; WinNT4.0; de-AT; rv:1.7.11) Gecko/20050728",
            ]
        }
    }
    
}
