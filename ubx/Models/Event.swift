import Foundation

class Event: NSObject {

    var name: String
    var date: String
    var status: String
    
    init(name: String, date: String, status: String) {
        self.name = name
        self.date = date
        self.status = date
    }
    
}
