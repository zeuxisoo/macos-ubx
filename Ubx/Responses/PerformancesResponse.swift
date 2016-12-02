import ObjectMapper

class PerformancesResponse: Mappable {
    
    var isFirstDayPerformance: Bool?
    var performanceAcsId: Int?
    var performanceDisplayFormat: String?
    var eventId: Int?
    var performanceId: Int?
    var bookmarkCreateTime: Int?
    var bookmarkStatus: Int?
    var performanceCategoryClass: String?
    var transactionMaxQuota: Int?
    var performanceDateTime: Int64?
    var isPurchasable: Bool?
    var counterSalesStartDate: String?
    var counterSalesEndDate: String?
    var displayDate: Bool?
    var displayTime: Bool?
    var externalReferenceKey: String?
    var performanceDisplayFormatValue: Int?
    var isNotAllowedToPurchaseBeforeShowTime: Bool?
    var note: String?
    var performanceName: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        self.isFirstDayPerformance <- map["isFirstDayPerformance"]
        self.performanceAcsId <- map["performanceAcsId"]
        self.performanceDisplayFormat <- map["performanceDisplayFormat"]
        self.eventId <- map["eventId"]
        self.performanceId <- map["performanceId"]
        self.bookmarkCreateTime <- map["bookmarkCreateTime"]
        self.bookmarkStatus <- map["bookmarkStatus"]
        self.performanceCategoryClass <- map["performanceCategoryClass"]
        self.transactionMaxQuota <- map["transactionMaxQuota"]
        self.performanceDateTime <- map["performanceDateTime"]
        self.isPurchasable <- map["isPurchasable"]
        self.counterSalesStartDate <- map["counterSalesStartDate"]
        self.counterSalesEndDate <- map["counterSalesEndDate"]
        self.displayDate <- map["displayDate"]
        self.displayTime <- map["displayTime"]
        self.externalReferenceKey <- map["externalReferenceKey"]
        self.performanceDisplayFormatValue <- map["performanceDisplayFormatValue"]
        self.isNotAllowedToPurchaseBeforeShowTime <- map["isNotAllowedToPurchaseBeforeShowTime"]
        self.note <- map["note"]
        self.performanceName <- map["performanceName"]
    }
    
}
