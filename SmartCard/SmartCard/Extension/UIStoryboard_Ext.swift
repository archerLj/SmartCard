//
//  UIStoryboard_Ext.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/20.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    enum Storyboard: String {
        case Login
        case Card
        case History
        case Setting
    }
    
    class func storyboard(storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    func initViewController<T: UIViewController>() -> T {
        let optionalVC = self.instantiateViewController(withIdentifier: T.storyboardIdentifier)
        
        guard let vc = optionalVC as? T else {
            fatalError("Couldn't initial view controller with identifier \(T.storyboardIdentifier)")
        }
        
        return vc
    }
}
