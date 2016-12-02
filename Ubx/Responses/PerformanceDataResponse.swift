import ObjectMapper

class PerformanceDataResponse: Mappable {
    
    var performances: [PerformancesResponse]?
    var status: [String]?
    
    required init?(map: Map){
        
    }

    func mapping(map: Map) {
        performances <- map["performanceList"]
        status <- map["performanceQuotaStatusList"]
    }
    
}
