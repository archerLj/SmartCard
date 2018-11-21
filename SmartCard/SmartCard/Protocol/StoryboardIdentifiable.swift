//
//  StoryboardIdentifiable.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/20.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self : UIViewController {
    static var storyboardIdentifier: String {
        return String.className(cs: self)
//        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
