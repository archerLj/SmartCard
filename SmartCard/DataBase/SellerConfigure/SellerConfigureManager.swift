//
//  SellerConfigureManager.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/26.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import CoreData

class SellerConfigureManager {
    class func save(sellerName: String, minPay: Int16, maxPay: Int16) -> Bool {
        
        guard let manageContext = getManagedContext() else { return false }
        
        let entity = NSEntityDescription.entity(forEntityName: "SellerConfigure", in: manageContext)!
        let sellerConfigure = NSManagedObject(entity: entity, insertInto: manageContext) as! SellerConfigure
        
        sellerConfigure.sellerName = sellerName
        sellerConfigure.minPay = minPay
        sellerConfigure.maxPay = maxPay
        
        do {
            try manageContext.save()
            return true
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
    }

    class func get(sellerName: String) -> SellerConfigure? {
        guard let manageContext = getManagedContext() else { return nil }
        
        let fetch: NSFetchRequest<SellerConfigure> = SellerConfigure.fetchRequest()
        fetch.predicate = NSPredicate(format: "sellerName = %@", sellerName)
        
        do {
            let results = try manageContext.fetch(fetch)
            if results.count > 0 {
                return results.first
            }
            return nil
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    class func getAll() -> [SellerConfigure]? {
        guard let manageContext = getManagedContext() else { return nil }
        
        let fetch: NSFetchRequest<SellerConfigure> = SellerConfigure.fetchRequest()
        
        do {
            let results = try manageContext.fetch(fetch)
            return results.count > 0 ? results : nil
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    class func delete(sellerName: String) -> Bool {
        guard let manageContext = getManagedContext() else { return false }
        guard let cellerConfigure = get(sellerName: sellerName) else { return false }
        
        manageContext.delete(cellerConfigure)
        return true
    }
}
