import Foundation
import Alamofire
import PromiseKit
import AlamofireObjectMapper
import SwiftyJSON

class Service {
    
    static let sharedInstance = Service()
    
    var agent: Alamofire.SessionManager?
    
    private init() {
        // Init web agnet
        self.agent = Alamofire.SessionManager(
            configuration: self.makeConfiguration()
        )
    }
    
    func makeConfiguration() -> URLSessionConfiguration {
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

        return configuration
    }
    
    func withProxy(host: String, port: Int) -> Service {
        debugPrint("Proxying")
        
        let configuration = self.makeConfiguration()
        
        configuration.connectionProxyDictionary = [
            kCFNetworkProxiesHTTPEnable as AnyHashable: true,
            kCFNetworkProxiesHTTPProxy as AnyHashable: host,
            kCFNetworkProxiesHTTPPort as AnyHashable: port,
        ]
        
        self.agent = Alamofire.SessionManager(
            configuration: configuration
        )
        
        return self
    }
    
    func fetchAuth() -> Promise<String> {
        return Promise { fulfill, reject in
            self.agent!.request("http://www.urbtix.hk/", method: .get).responseString(completionHandler: { response in
                switch response.result {
                    case .success:
                        if let cookie = response.response?.allHeaderFields["Set-Cookie"] {
                            fulfill(cookie as! String)
                        }else{
                            reject("Cannot got auth cookie" as! Error)
                        }
                    case .failure(let error):
                        reject(error)
                }
            })
        }
    }
    
    func fetchPerformanceList(eventId: Int, pageNo: Int, perPage: Int = 10) -> Promise<PerformanceDataResponse> {
        let timestamp = self.timestamp()
        let targetURL = "https://ticket.urbtix.hk/internet/json/event/\(eventId)/performance/\(perPage)/\(pageNo)/perf.json?locale=zh_TW&\(timestamp)"
        
        return Promise { fulfill, reject in
            // Make sure it was delayed not request too fast after fetchAuth method
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1) , execute: {
                self.agent!.request(targetURL, method: .get).responseObject(completionHandler: { (response: DataResponse<PerformanceDataResponse>) in
                    switch response.result {
                        case .success:
                            let performanceData = response.result.value!
                            
                            fulfill(performanceData)
                        case .failure(let error):
                            reject(error)
                    }
                })
            })
        }
    }
    
    func fetchProxyTest(success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        self.agent!.request("http://httpbin.org/ip", method: .get).responseJSON { response in
            switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let origin = json["origin"].stringValue
                    
                    success(origin.isEmpty == false)
                    break
                case .failure(let error):
                    failure(error)
                    break
            }
        }
    }
    
}
