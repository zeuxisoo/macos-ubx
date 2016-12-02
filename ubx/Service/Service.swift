import Foundation
import Alamofire

class Service {
    
    public static let sharedInstance = Service()
    
    private var agent: Alamofire.SessionManager?
    
    private init() {
        // Header and connection configuration
        let configuration = URLSessionConfiguration.default
        
        configuration.httpCookieAcceptPolicy = .always
        configuration.timeoutIntervalForRequest = 5
        configuration.httpAdditionalHeaders = [
            "Accept"         : "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
            "Accept-Language": "en-US,en;q=0.8",
            "Connection"     : "keep-alive",
            "User-Agent"     : self.randomUserAgent()
        ]
        
        // Init web agnet
        self.agent = Alamofire.SessionManager(
            configuration: configuration
        )
    }
    
    public func fetchTest() {
        self.agent!.request("https://httpbin.org/ip", method: .get).responseJSON(completionHandler: { response in
            debugPrint(response)
        })
    }
    
}
