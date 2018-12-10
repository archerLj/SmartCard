//
//  PayRecord+CoreDataProperties.swift
//  
//
//  Created by archerLj on 2018/12/6.
//
//

import Foundation
import CoreData


extension PayRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PayRecord> {
        return NSFetchRequest<PayRecord>(entityName: "PayRecord")
    }

    @NSManaged public var cardNum: String
    @NSManaged public var sellerName: String?
    @NSManaged public var payNum: Float
    @NSManaged public var payWay: String?
    @NSManaged public var charge: Float
    @NSManaged public var settleMented: Bool
    @NSManaged public var settleDate: String?
    @NSManaged public var payDate: String?
    @NSManaged public var repaymented: Bool

}
