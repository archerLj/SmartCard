//
//  CardInfo+CoreDataProperties.swift
//  
//
//  Created by archerLj on 2018/11/22.
//
//

import Foundation
import CoreData
import UIKit


extension CardInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardInfo> {
        return NSFetchRequest<CardInfo>(entityName: "CardInfo")
    }
    
    @nonobjc public class func getNew() -> CardInfo? {
        guard let managedContext = getManagedContext() else {
            return nil
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "CardInfo", in: managedContext)!
        return NSManagedObject(entity: entity, insertInto: managedContext) as! CardInfo
    }

    /// 银行ID(同SCBanks中银行索引一致)
    @NSManaged public var bankID: Int16
    
    /// 信用卡卡号
    @NSManaged public var cardNumber: String?
    
    /// 账单日
    @NSManaged public var creditBillDate: Int16
    
    /// 信用额度
    @NSManaged public var creditLines: Int32
    
    /// 还款提醒
    @NSManaged public var repaymentWarningDay: Int16
}
