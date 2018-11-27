//
//  PayPlanManager.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/26.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import CoreData

class PayPlanManager {
    class func save(startHour: Int16, endHour: Int16, sellerNames: String) -> PayPlan? {
        guard let manageContext = getManagedContext() else {
            return nil
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "PayPlan", in: manageContext)!
        let payPlan = NSManagedObject(entity: entity, insertInto: manageContext) as! PayPlan
    
        payPlan.startHour = startHour
        payPlan.endHour = endHour
        payPlan.sellerNames = sellerNames
        
        do {
            try manageContext.save()
            return payPlan
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    class func getAll() -> [PayPlan]? {
        guard let manageContext = getManagedContext() else { return nil }
        
        let fetch: NSFetchRequest<PayPlan> = PayPlan.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "startHour", ascending: true),
                                 NSSortDescriptor(key: "endHour", ascending: true)]
        
        do {
            let rs = try manageContext.fetch(fetch)
            return rs
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    class func update(startHour: Int16, endHour: Int16, sellerNames: String) -> PayPlan? {
        guard let plan = get(startHour: startHour, endHour: endHour) else {
            return nil
        }
        
        guard let manageContext = getManagedContext() else {
            return nil
        }
        
        plan.sellerNames = sellerNames
        do {
            try manageContext.save()
            return plan
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    class func get(startHour: Int16, endHour: Int16) -> PayPlan? {
        guard let manageContext = getManagedContext() else { return nil }
        
        let fetch: NSFetchRequest<PayPlan> = PayPlan.fetchRequest()
        fetch.predicate = NSPredicate(format: "startHour = %d and endHour = %d", startHour, endHour)
        
        do {
            let rs = try manageContext.fetch(fetch)
            if rs.count > 0 {
                return rs.first
            } else {
                return nil
            }
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    class func delete(startHour: Int16, endHour: Int16) -> Bool {
        guard let manageContext = getManagedContext() else { return false }
        
        guard let payPlan = get(startHour: startHour, endHour: endHour) else { return false }
        
        manageContext.delete(payPlan)
        return true
    }
}
