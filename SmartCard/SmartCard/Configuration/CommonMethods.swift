//
//  CommonMethods.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/19.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation

func delay(_ delay: TimeInterval, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: execute)
}
