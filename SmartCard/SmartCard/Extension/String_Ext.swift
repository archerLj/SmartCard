//
//  String_Ext.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/20.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation

extension String {
    static func className(cs: AnyClass) -> String {
        return NSStringFromClass(cs).components(separatedBy: ".").last!
    }
}
