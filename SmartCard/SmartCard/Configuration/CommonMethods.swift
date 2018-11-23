//
//  CommonMethods.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/19.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import UIKit
import PKHUD
import CoreData

func delay(_ delay: TimeInterval, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: execute)
}

func getManagedContext() -> NSManagedObjectContext? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return nil
    }
    
    return appDelegate.persistentContainer.viewContext
}

func showErrorHud(title: String) {
    PKHUD.sharedHUD.contentView = PKHUDErrorView(title: nil, subtitle: title)
    PKHUD.sharedHUD.show()
    PKHUD.sharedHUD.hide(afterDelay: 3.0)
}

func showSuccessHud(title: String) {
    PKHUD.sharedHUD.contentView = PKHUDSuccessView(title: nil, subtitle: title)
    PKHUD.sharedHUD.show()
    PKHUD.sharedHUD.hide(afterDelay: 3.0)
}
