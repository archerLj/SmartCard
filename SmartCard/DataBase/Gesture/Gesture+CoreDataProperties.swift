//
//  Gesture+CoreDataProperties.swift
//  
//
//  Created by archerLj on 2018/11/29.
//
//

import Foundation
import CoreData


extension Gesture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gesture> {
        return NSFetchRequest<Gesture>(entityName: "Gesture")
    }

    /// 手势字符串
    @NSManaged public var gestureSequence: String?

}
