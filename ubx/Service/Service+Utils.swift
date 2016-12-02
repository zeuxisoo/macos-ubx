import Foundation

extension Service {
    
    public func randomUserAgent() -> String {
        let userAgents = [
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36",
            "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fr) AppleWebKit/416.12 (KHTML, like Gecko) Safari/412.5",
            "Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120819 Firefox/15.0 PaleMoon/15.0",
            "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; GTB6; Acoo Browser; .NET CLR 1.1.4322; .NET CLR 2.0.50727)",
            "Mozilla/5.0 (Windows; U; Windows NT 5.1; pt-BR) AppleWebKit/534.12 (KHTML, like Gecko) NavscapeNavigator/Pre-0.1 Safari/534.12",
            "Mozilla/5.0 (Windows; U; WinNT4.0; de-AT; rv:1.7.11) Gecko/20050728",
            ]
        let randomIndex = Int(arc4random_uniform(UInt32(userAgents.count)))
        
        return userAgents[randomIndex]
    }
    
    public func timestamp() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
    
}
