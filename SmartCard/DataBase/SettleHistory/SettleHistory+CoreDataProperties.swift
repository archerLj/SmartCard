//
//  SettleHistory+CoreDataProperties.swift
//  
//
//  Created by archerLj on 2018/12/6.
//
//

import Foundation
import CoreData


extension SettleHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettleHistory> {
        return NSFetchRequest<SettleHistory>(entityName: "SettleHistory")
    }

    @NSManaged public var bankID: Int16
    /// 上一期总刷卡量
    @NSManaged public var payNum: Float
    /// 上一期总手续费
    @NSManaged public var charge: Float
    /// 结算日期
    @NSManaged public var settleDate: String?

}
