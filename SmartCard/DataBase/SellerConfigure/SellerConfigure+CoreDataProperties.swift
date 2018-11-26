//
//  SellerConfigure+CoreDataProperties.swift
//  
//
//  Created by archerLj on 2018/11/26.
//
//

import Foundation
import CoreData


extension SellerConfigure {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SellerConfigure> {
        return NSFetchRequest<SellerConfigure>(entityName: "SellerConfigure")
    }

    /// 商户类型名称
    @NSManaged public var sellerName: String?
    
    /// 最小消费
    @NSManaged public var minPay: Int16
    
    /// 最大消费
    @NSManaged public var maxPay: Int16

}
