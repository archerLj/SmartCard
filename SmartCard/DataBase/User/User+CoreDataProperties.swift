//
//  User+CoreDataProperties.swift
//  
//
//  Created by archerLj on 2018/12/7.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var account: String?
    @NSManaged public var password: String?
    /// 手势密码
    @NSManaged public var gestureSequence: String?
    @NSManaged public var postrait: NSData?

}
