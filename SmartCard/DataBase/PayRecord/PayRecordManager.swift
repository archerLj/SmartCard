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
    
    class func save(bankIDs: Set<Int>,
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
        for bankID in bankIDs {
            let payRecord = NSManagedObject(entity: entity, insertInto: manageContext) as! PayRecord
            
            payRecord.bankID = Int16(bankID)
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
                return Dictionary(grouping: results, by: { $0.bankID }).map { $1 }
            } else {
                return nil
            }
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    /// 获取当天的刷卡量
    class func getPayNumsOfToday(bankIDs: [Int16]) -> [Float?] {
        guard let manageContext = getManagedContext() else {
            return [Float?](repeating: nil, count: bankIDs.count)
        }
        
        let fetch: NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
        
        var results = [Float?]()
        for bankID in bankIDs {
            fetch.predicate = NSPredicate(format: "bankID = \(bankID)")
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
            
            let bankRecords = Dictionary(grouping: results, by: {$0.bankID}).map{$1}
            for bds in bankRecords {
                let payNums = bds.map { $0.payNum }.reduce(0, +)
                let charges = bds.map { $0.charge }.reduce(0, +)
                let settleHistory = NSManagedObject(entity: entity, insertInto: manageContext) as! SettleHistory
                settleHistory.bankID = bds[0].bankID
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
    
    class func repayment(bankID: Int16) -> Bool {
        guard let manageContext = getManagedContext() else {
            return false
        }
        
        let fetch: NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
        fetch.predicate = NSPredicate(format: "settleMented = true and repaymented = false and bankID = \(bankID)")
        
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
    
    class func getRecordsNotSettled(bankID: Int16) -> [PayRecord]? {
        guard let manageContext = getManagedContext() else {
            return nil
        }
        
        let fetch: NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
        fetch.predicate = NSPredicate(format: "bankID = %@", bankID)
        fetch.predicate = NSPredicate(format: "settleMented = false")
        
        do {
            let rs = try manageContext.fetch(fetch)
            return rs.count > 0 ? rs : nil
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
//    func regroup<T, U: Hashable>(array: [T], by trans: (T) -> U) -> [[T]] {
//        var dic = [U: [T]]()
//        array.forEach {
//            if dic[trans($0)] == nil {
//                dic[trans($0)] = [$0]
//            } else {
//                dic[trans($0)]!.append($0)
//            }
//        }
//        return dic.map {$1}
//    }
    
    /// 获取今日刷卡记录
    class func getPayRecodesThisDay() -> [[PayRecord]]? {
        guard let manageContext = getManagedContext() else {
            return nil
        }
        
        let formate = DateFormatter()
        formate.dateFormat = "yyyy-MM-dd"
        let dateToday = formate.string(from: Date())
        
        let fetch: NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
        fetch.predicate = NSPredicate(format: "payDate like %@", dateToday + "*")
        fetch.sortDescriptors = [NSSortDescriptor(key: "bankID", ascending: false)]
        
        do {
            let resuts = try manageContext.fetch(fetch)
            return Dictionary(grouping: resuts, by: {$0.bankID}).map{$1}
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
        return getUnsettlePayNumACharges(bankID: nil)
    }
    
    /// 获取某张卡本期刷卡量和手续费
    class func getUnsettlePayNumACharges(bankID: Int16?) -> (payNums: Float, charges: Float) {
        guard let manageContext = getManagedContext() else {
            return (0, 0)
        }
        
        let fetch: NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
        if let bankID = bankID {
            fetch.predicate = NSPredicate(format: "settleMented = false and bankID = \(bankID)")
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
    class func getLastSettlePayNumACharges(bankID: Int16) -> (payNums: Float, charges: Float) {
        guard let manageContext = getManagedContext() else {
            return (0, 0)
        }
        
        let fetch: NSFetchRequest<PayRecord> = PayRecord.fetchRequest()
        fetch.predicate = NSPredicate(format: "settleMented = true and repaymented = false and bankID = \(bankID)")
        
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
