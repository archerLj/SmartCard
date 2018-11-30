//
//  GestureManage.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/29.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import CoreData

class GestureManager {
    class func save(sequence: String) -> Bool {
        guard let manageContext = getManagedContext() else {
            return false
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Gesture", in: manageContext)!
        let gesture = NSManagedObject(entity: entity, insertInto: manageContext) as! Gesture
        
        gesture.gestureSequence = sequence
        do {
            try manageContext.save()
            return true
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
    }
    
    class func get() -> String? {
        guard let manageContext = getManagedContext() else {
            return nil
        }
        
        let fetch: NSFetchRequest<Gesture> = Gesture.fetchRequest()
        
        do {
            let rs = try manageContext.fetch(fetch)
            return rs.first?.gestureSequence
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
}
