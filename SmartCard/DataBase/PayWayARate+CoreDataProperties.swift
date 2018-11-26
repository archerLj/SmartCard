//
//  PayWayARate+CoreDataProperties.swift
//  
//
//  Created by archerLj on 2018/11/26.
//
//

import Foundation
import CoreData


extension PayWayARate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PayWayARate> {
        return NSFetchRequest<PayWayARate>(entityName: "PayWayARate")
    }

    /// 刷卡方式
    @NSManaged public var payWay: String?
    
    /// 费率
    @NSManaged public var rate: Float

}
