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
              quickPayLines: Int16,
              gracePeriod: Int16) -> CardInfo? {
        
        guard let managedContext = getManagedContext() else {
            return nil
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "CardInfo", in: managedContext)!
        let cardInfo = NSManagedObject(entity: entity, insertInto: managedContext) as! CardInfo
        
        cardInfo.bankID = bankID
        cardInfo.cardNumber = cardNumber
        cardInfo.creditBillDate = creditBillDate
        cardInfo.creditLines = creditLines
        cardInfo.quickPayLines = quickPayLines
        cardInfo.gracePeriod = gracePeriod
        
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
                      quickPayLines: Int16,
                      gracePeriod: Int16) -> CardInfo? {
        
        guard let cardInfo = get(cardNumber: cardNumber) else {
            return nil
        }
        
        guard let managedContext = getManagedContext() else {
            return nil
        }
        
        cardInfo.creditBillDate = creditBillDate
        cardInfo.creditLines = creditLines
        cardInfo.quickPayLines = quickPayLines
        cardInfo.gracePeriod = gracePeriod
        
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
}
