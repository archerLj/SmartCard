//
//  PayWayARateManager.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/26.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import CoreData

class PayWayARateManager {
    class func save(payWay: String, rate: Float, charge: Float) -> Bool {
        guard let manageContext = getManagedContext() else {
            return false
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "PayWayARate", in: manageContext)!
        let payWayARate = NSManagedObject(entity: entity, insertInto: manageContext) as! PayWayARate
        
        payWayARate.payWay = payWay
        payWayARate.rate = rate
        payWayARate.charge = charge
        
        do {
            try manageContext.save()
            return true
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
    }
    
    class func getAll() -> [PayWayARate]? {
        guard let manageContext = getManagedContext() else {
            return nil
        }
        
        let fetch: NSFetchRequest<PayWayARate> = PayWayARate.fetchRequest()
        
        do {
            let results = try manageContext.fetch(fetch)
            return results
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    class func delete(payWay: String) -> Bool {
        guard let manageContext = getManagedContext() else {
            return false
        }
        
        let fetch: NSFetchRequest<PayWayARate> = PayWayARate.fetchRequest()
        fetch.predicate = NSPredicate(format: "payWay = %@", payWay)
        
        do {
            let result = try manageContext.fetch(fetch)
            for rs in result {
                manageContext.delete(rs)
            }
            return true
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
    }
}
