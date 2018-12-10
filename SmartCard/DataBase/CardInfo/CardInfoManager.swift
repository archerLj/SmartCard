//
//  CardInfoManager.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/22.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import CoreData

class CardInfoManager {
    class func save(bankID: Int16,
              cardNumber: String,
              creditBillDate: Int16,
              creditLines: Int32,
              repaymentWarningDay: Int16) -> CardInfo? {
        
        guard let managedContext = getManagedContext() else {
            return nil
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "CardInfo", in: managedContext)!
        let cardInfo = NSManagedObject(entity: entity, insertInto: managedContext) as! CardInfo
        
        cardInfo.bankID = bankID
        cardInfo.cardNumber = cardNumber
        cardInfo.creditBillDate = creditBillDate
        cardInfo.creditLines = creditLines
        cardInfo.repaymentWarningDay = repaymentWarningDay
        
        do {
            try managedContext.save()
            return cardInfo
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    class func update(cardNumber: String,
                      creditBillDate: Int16,
                      creditLines: Int32,
                      repaymentWarningDay: Int16) -> CardInfo? {
        
        guard let cardInfo = get(cardNumber: cardNumber) else {
            return nil
        }
        
        guard let managedContext = getManagedContext() else {
            return nil
        }
        
        cardInfo.creditBillDate = creditBillDate
        cardInfo.creditLines = creditLines
        cardInfo.repaymentWarningDay = repaymentWarningDay
        
        do {
            try managedContext.save()
            return cardInfo
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    class func remove(cardNumber: String) -> Bool {
        guard let cardInfo = get(cardNumber: cardNumber) else {
            return false
        }
        guard let managedContext = getManagedContext() else {
            return false
        }
        
        managedContext.delete(cardInfo)
        return true
    }
    
    class func get(cardNumber: String) -> CardInfo? {
        guard let managedContext = getManagedContext() else {
            return nil
        }
        
        let predicate = NSPredicate(format: "cardNumber = %@", cardNumber)
        let request: NSFetchRequest<CardInfo> = CardInfo.fetchRequest()
        request.predicate = predicate
        
        do {
            let cardInfos = try managedContext.fetch(request)
            return cardInfos.first
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    class func getAll() -> [CardInfo]? {
        guard let managedContext = getManagedContext() else {
            return nil
        }
        
        let request: NSFetchRequest<CardInfo> = CardInfo.fetchRequest()
        
        do {
            let cardInfos = try managedContext.fetch(request)
            return cardInfos
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    /// 获取所有信用卡信息并按账单日分组
    class func getAllGroupedByCreditBillDate() -> [[CardInfo]]? {
        guard let rs = getAll() else {
            return nil
        }
        
        return Dictionary(grouping: rs, by: {$0.creditBillDate}).map{$1}.sorted(by: { (a, b) -> Bool in
            let a0 = a[0]
            let b0 = b[0]
            return a0.creditBillDate < b0.creditBillDate
        })
    }
    
    class func getBankAndCardNums() -> (bankNums: Int, cardNums: Int) {
        guard let manageContext = getManagedContext() else {
            return (0, 0)
        }
        
        let fetch: NSFetchRequest<CardInfo> = CardInfo.fetchRequest()
        
        do {
            let results = try manageContext.fetch(fetch)
            if results.count > 0 {
                let grouped = Dictionary(grouping: results, by: { $0.bankID }).map {$1}
                return (grouped.count, results.count)
            }
            return (0, 0)
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return (0, 0)
        }
    }
    
    class func getBankID(cardNum: String) -> Int? {
        guard let manageContext = getManagedContext() else { return nil }
        
        let fetch: NSFetchRequest<CardInfo> = CardInfo.fetchRequest()
        fetch.predicate = NSPredicate(format: "cardNumber = %@", cardNum)
        
        do {
            let results = try manageContext.fetch(fetch)
            if results.count > 0 {
                return Int(results[0].bankID)
            }
            return nil
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
}
