//
//  PayWayARate+CoreDataProperties.swift
//  
//
//  Created by archerLj on 2018/12/4.
//
//

import Foundation
import CoreData


extension PayWayARate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PayWayARate> {
        return NSFetchRequest<PayWayARate>(entityName: "PayWayARate")
    }

    /// 支付方式
    @NSManaged public var payWay: String?
    /// 费率
    @NSManaged public var rate: Float
    /// 单笔手续费
    @NSManaged public var charge: Float

}
