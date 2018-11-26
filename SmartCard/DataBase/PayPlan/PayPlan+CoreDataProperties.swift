//
//  PayPlan+CoreDataProperties.swift
//  
//
//  Created by archerLj on 2018/11/26.
//
//

import Foundation
import CoreData


extension PayPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PayPlan> {
        return NSFetchRequest<PayPlan>(entityName: "PayPlan")
    }

    /// 开始时间
    @NSManaged public var startHour: Int16
    
    /// 结束时间
    @NSManaged public var endHour: Int16
    
    /// 商户名称列表
    @NSManaged public var sellerNames: String?

}
