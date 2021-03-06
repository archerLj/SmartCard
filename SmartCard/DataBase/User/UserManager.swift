//
//  UserManager.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/30.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import CoreData

class UserManager {
    class func save(account: String, password: String) -> Bool {
        guard let manageContext = getManagedContext() else {
            return false
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: manageContext)!
        let user = NSManagedObject(entity: entity, insertInto: manageContext) as! User
        
        user.account = account
        user.password = password.getMD5()
        
        do {
            try manageContext.save()
            return true
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
    }
    
    class func getUser(account: String) -> User? {
        guard let manageContext = getManagedContext() else {
            return nil
        }
        
        let fetch: NSFetchRequest<User> = User.fetchRequest()
        fetch.predicate = NSPredicate(format: "account = %@", account)
        
        do {
            let results = try manageContext.fetch(fetch)
            return results.first
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    class func isUserOrPwdPassed(account: String, pwd: String) -> User? {
        if let user = getUser(account: account) {
            if user.password == pwd.getMD5() {
                return user
            }
            return nil
        } else {
            return nil
        }
    }
    
    class func getUserBy(gesture: String) -> User? {
        guard let manageContext = getManagedContext() else {
            return nil
        }
        
        let fetch: NSFetchRequest<User> = User.fetchRequest()
        fetch.predicate = NSPredicate(format: "gestureSequence = \(gesture)")
        
        do {
            let results = try manageContext.fetch(fetch)
            return results.count > 0 ? results[0] : nil
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return nil
        }
    }
    
    class func saveOrUpdateInfos(postrait: Data?, brefIntroduction: String?, account: String) -> Bool {
        guard let manageContext = getManagedContext() else { return false }
        
        let fetch: NSFetchRequest<User> = User.fetchRequest()
        fetch.predicate = NSPredicate(format: "account = %@", account)
        
        do {
            let results = try manageContext.fetch(fetch)
            if results.count > 0 {
                results[0].postrait = postrait
                results[0].brefIntroduction = brefIntroduction
                try manageContext.save()
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
    }
    
    /// 保存或更新指纹
    class func saveOrUpdateGesture(gesture: String, userName: String) -> Bool {
        guard let manageContext = getManagedContext() else { return false }
        
        let fetch: NSFetchRequest<User> = User.fetchRequest()
        fetch.predicate = NSPredicate(format: "account = %@", userName)
        
        do {
            let results = try manageContext.fetch(fetch)
            if results.count > 0 {
                results[0].gestureSequence = gesture
                try manageContext.save()
                return true
            } else {
                return false
            }
            
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
    }
}
