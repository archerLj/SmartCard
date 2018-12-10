//
//  PayRecordManager.swift
//  SmartCard
//
//  Created by archerLj on 2018/12/5.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import CoreData

class PayRecordManager {
    
    class func save(cardNums: Set<String>,
                    sellerName: String,
                    payNum: Float,
                    payWay: String,
                    charge: Float,
                    settleMented: Bool,
                    settleDate: String,
                    payDate: String) -> Bool {
        guard let manageContext = getManagedContext() else {
            return false
        }
        let entity = NSEntityDescription.entity(forEntityName: "PayRecord", in: manageContext)!
        for cardNum in cardNums {
            let payRecord = NSManagedObject(entity: entity, insertInto: manageContext) as! PayRecord
            
            payRecord.cardNum = cardNum
            payRecord.charge = charge
            payRecord.payNum = payNum
            payRecord.payWay = payWay
            payRecord.sellerName = sellerName
            payRecord.settleDate = settleDate
            payRecord.settleMented = settleMented
            payRecord.payDate = payDate
        }
        
        do {
            try manageContext.save()
            return true
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
    }
    
    class func getPayRecords(date: String) -> [[PayRecord]]? {
        guard let manageContext = getManagedContext() else {
            return nil
        }
        
        let fetch: NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
        fetch.predicate = NSPredicate(format: "payDate CONTAINS %@", date)
        
        do {
            let results = try manageContext.fetch(fetch)
            if results.count > 0 {
                return Dictionary(grouping: results, by: { $0.cardNum }).map { $1 }
            } else {
                return nil
            }
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    /// 获取当天的刷卡量
    class func getPayNumsOfToday(cardNums: [String]) -> [Float?] {
        guard let manageContext = getManagedContext() else {
            return [Float?](repeating: nil, count: cardNums.count)
        }
        
        let fetch: NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
        
        var results = [Float?]()
        for cardNum in cardNums {
            fetch.predicate = NSPredicate(format: "cardNum = \(cardNum)")
            do {
                let rs = try manageContext.fetch(fetch)
                let payNums = rs.map { $0.payNum }.reduce(0, +)
                results.append(payNums)
            } catch let error as NSError {
                print("\(error), \(error.userInfo)")
                results.append(nil)
            }
        }
        return results
    }
    
    /// 删除某个刷卡时间的所有刷卡记录
    class func delete(payDate: String) -> Bool {
        guard let manageContext = getManagedContext() else {
            return false
        }
        
        let fetch:NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
        fetch.predicate = NSPredicate(format: "payDate = %@", payDate)
        
        do {
            let results = try manageContext.fetch(fetch)
            for rs in results {
                manageContext.delete(rs)
            }
            return true
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
    }
    
    /// 结算
    class func settle() -> Bool {
        guard let manageContext = getManagedContext() else {
            return false
        }
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let dateNow = dateFormat.string(from: Date())
        
        let fetch: NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
        fetch.predicate = NSPredicate(format: "settleMented = false")
        
        let entity = NSEntityDescription.entity(forEntityName: "SettleHistory", in: manageContext)!
        
        do {
            let results = try manageContext.fetch(fetch)
            for rs in results {
                rs.settleMented = true
                rs.settleDate = dateNow
            }
            
            let bankRecords = Dictionary(grouping: results, by: {$0.cardNum}).map{$1}
            for bds in bankRecords {
                let payNums = bds.map { $0.payNum }.reduce(0, +)
                let charges = bds.map { $0.charge }.reduce(0, +)
                let settleHistory = NSManagedObject(entity: entity, insertInto: manageContext) as! SettleHistory
                settleHistory.cardNum = bds[0].cardNum
                settleHistory.payNum = payNums
                settleHistory.charge = charges
                settleHistory.settleDate = dateNow
            }
            
            try manageContext.save()
            return true
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
    }
    
    class func repayment(cardNum: String) -> Bool {
        guard let manageContext = getManagedContext() else {
            return false
        }
        
        let fetch: NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
        fetch.predicate = NSPredicate(format: "settleMented = true and repaymented = false and cardNum = \(cardNum)")
        
        do {
            let results = try manageContext.fetch(fetch)
            for rs in results {
                rs.repaymented = true
            }
            try manageContext.save()
            return true
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
    }
    
    class func getRecordsNotSettled(cardNum: String) -> [PayRecord]? {
        guard let manageContext = getManagedContext() else {
            return nil
        }
        
        let fetch: NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
        fetch.predicate = NSPredicate(format: "cardNum = %@", cardNum)
        fetch.predicate = NSPredicate(format: "settleMented = false")
        
        do {
            let rs = try manageContext.fetch(fetch)
            return rs.count > 0 ? rs : nil
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    /// 获取上期刷卡量和手续费
    class func getLastSettlePayNumACharges() -> (payNums: Float, charges: Float) {
        return SettleHistoryManager.getAllCardsLastSettlePayNumsAndCharges()
    }
    
    /// 获取本期刷卡量和手续费
    class func getUnSettlePayNumACharges() -> (payNums: Float, charges: Float) {
        return getUnsettlePayNumACharges(cardNum: nil)
    }
    
    /// 获取某张卡本期刷卡量和手续费
    class func getUnsettlePayNumACharges(cardNum: String?) -> (payNums: Float, charges: Float) {
        guard let manageContext = getManagedContext() else {
            return (0, 0)
        }
        
        let fetch: NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
        if let cardNum = cardNum {
            fetch.predicate = NSPredicate(format: "settleMented = false and cardNum = \(cardNum)")
        } else {
            fetch.predicate = NSPredicate(format: "settleMented = false")
        }
        
        do {
            let results = try manageContext.fetch(fetch)
            let payNums = results.map { $0.payNum }.reduce(0, +)
            let charges = results.map { $0.charge }.reduce(0, +)
            return (payNums, charges)
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return (0, 0)
        }
    }
    
    /// 获取某张卡上期未还款刷卡量和手续费
    class func getLastSettlePayNumACharges(cardNum: String) -> (payNums: Float, charges: Float) {
        return SettleHistoryManager.getLastSettlePayNumsAndCharges(cardNum:cardNum)
//        guard let manageContext = getManagedContext() else {
//            return (0, 0)
//        }
//
//        let fetch: NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
//        fetch.predicate = NSPredicate(format: "settleMented = true and repaymented = false and cardNum = \(cardNum)")
//
//        do {
//            let results = try manageContext.fetch(fetch)
//            let payNums = results.map { $0.payNum }.reduce(0, +)
//            let charges = results.map { $0.charge }.reduce(0, +)
//            return (payNums, charges)
//
//        } catch let error as NSError {
//            print("\(error), \(error.userInfo)")
//            return (0, 0)
//        }
    }
    
    /// 获取最近几期所有刷卡记录
    class func getRecentSettleNums(count: Int) -> [[PayRecord]] {
        guard let manageContext = getManagedContext() else {
            return [[]]
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "PayRecord", in: manageContext)!
        let fetch: NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
        fetch.propertiesToGroupBy = [entity.attributesByName["settleDate"]!]
        fetch.sortDescriptors = [NSSortDescriptor(key: "settleDate", ascending: false)]
        fetch.fetchLimit = 1
        
        // TODO
        do {
            let results = try manageContext.fetch(fetch)
            return [[]]
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return [[]]
        }
    }

}
