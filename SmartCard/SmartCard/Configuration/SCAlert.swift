//
//  SCAlert.swift
//  SmartCard
//
//  Created by archerLj on 2018/12/7.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import UIKit

class SCAlert {
    class func showWarning(title: String, message: String, cancelBtnTitle: String) -> UIAlertController {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelBtnTitle, style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        return alertVC
    }
}
