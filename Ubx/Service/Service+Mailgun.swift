//
//  Service+Mailgun.swift
//  Ubx
//
//  Created by Zeuxis on 19/12/2016.
//  Copyright © 2016 Zeuxis. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Service {
    
    typealias SendMailSuccess = (_ id: String, _ message: String) -> Void
    typealias SendMailFailure = (_ error: Error) -> Void
    
    func sendMail(domain: String, apiKey: String, from: String, to: String, subject: String, success: @escaping SendMailSuccess, failure: @escaping SendMailFailure) {
        let parameters = [
            "from"   : from,
            "to"     : to,
            "subject": subject,
            "text"   : "A new record found in the ubx monitor"
        ]
        
        self.agent!.request(
            "https://api.mailgun.net/v3/\(domain)/messages",
            method: .post,
            parameters: parameters
        )
        .authenticate(user: "api", password: apiKey)
        .responseJSON { response in
            switch response.result {
                case .success(let data):                    
                    let json = JSON(data)
                    
                    let id      = json["id"].stringValue
                    let message = json["message"].stringValue
                    
                    success(id, message)
                    break
                case .failure(let error):
                    failure(error)
                    break
            }
        }
    }
    
}
