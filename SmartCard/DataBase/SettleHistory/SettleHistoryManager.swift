//
//  SettleHistoryManager.swift
//  SmartCard
//
//  Created by archerLj on 2018/12/6.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import CoreData

class SettleHistoryManager {
    class func getLastSettlePayNumsAndCharges(cardNum: String) -> (payNums: Float, charges: Float) {
        guard let manageContext = getManagedContext() else {
            return (0, 0)
        }
        
        let fetch: NSFetchRequest<SettleHistory> = SettleHistory.fetchRequest()
        fetch.predicate = NSPredicate(format: "cardNum = \(cardNum)")
        fetch.fetchLimit = 1
        fetch.sortDescriptors = [NSSortDescriptor(key: "settleDate", ascending: true)]
        
        do {
            let results = try manageContext.fetch(fetch)
            if results.count > 0 {
                return (results[0].payNum, results[0].charge)
            }
            return (0, 0)
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return (0, 0)
        }
    }
    
    class func getAllCardsLastSettlePayNumsAndCharges() -> (payNums: Float, charges: Float) {
        guard let manageContext = getManagedContext() else {
            return (0, 0)
        }
        
        let fetch: NSFetchRequest<SettleHistory> = SettleHistory.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "settleDate", ascending: true)]
        
        do {
            let results = try manageContext.fetch(fetch)
            if results.count > 0 {
                var rs = Dictionary(grouping: results, by: { $0.settleDate }).map {$1}
                rs.sort { (a, b) -> Bool in
                    let aDate = a[0].settleDate!
                    let bDate = b[0].settleDate!
                    if aDate.compare(bDate) == .orderedDescending {
                        return true
                    }
                    return false
                }
                let payNums = rs[0].map { $0.payNum }.reduce(0, +)
                let charges = rs[0].map { $0.charge }.reduce(0, +)
                return (payNums, charges)
            } else {
                return (0, 0)
            }
            
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return (0, 0)
        }
    }
}
