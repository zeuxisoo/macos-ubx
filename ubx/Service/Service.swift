import Foundation
import Alamofire
import PromiseKit

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
    
    public func fetchAuth() -> Promise<String> {
        return Promise { fulfill, reject in
            self.agent!.request("http://www.urbtix.hk/", method: .get).responseString(completionHandler: { response in
                switch response.result {
                    case .success:
                        let cookie = response.response?.allHeaderFields["Set-Cookie"] as! String
                        
                        fulfill(cookie)
                    case .failure(let error):
                        reject(error)
                }
            })
        }
    }
    
    public func fetchPerformanceList(eventId: Int, pageNo: Int, perPage: Int = 10) -> Promise<String> {
        let timestamp = self.timestamp()
        let targetURL = "https://ticket.urbtix.hk/internet/json/event/\(eventId)/performance/\(perPage)/\(pageNo)/perf.json?locale=zh_TW&\(timestamp)"
        
        return Promise { fulfill, reject in
            self.agent!.request(targetURL, method: .get).responseString(completionHandler: { response in
                switch response.result {
                    case .success(let json):
                        fulfill(json)
                    case .failure(let error):
                        reject(error)
                }
            })
        }
    }
    
    public func fetchTest() {
        self.agent!.request("https://httpbin.org/ip", method: .get).responseJSON(completionHandler: { response in
            debugPrint(response)
        })
    }
    
}
