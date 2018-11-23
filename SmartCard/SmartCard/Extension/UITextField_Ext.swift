//
//  UITextField_Ext.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/22.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import UIKit

var textFieldMaxLengthKey = 1000

extension UITextField {
    
    @IBInspectable
    var maxLength: Int {
        set {
            objc_setAssociatedObject(self, &textFieldMaxLengthKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            if let rs = objc_getAssociatedObject(self, &textFieldMaxLengthKey) as? Int {
                return rs
            }
            return 0
        }
    }
}
