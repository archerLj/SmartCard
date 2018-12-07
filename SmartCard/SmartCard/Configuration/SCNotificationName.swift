//
//  SCNotificationNames.swift
//  SmartCard
//
//  Created by archerLj on 2018/12/6.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation

class SCNotificationName {
    
    /// 添加了新的信用卡
    class func newCreditCardAdded() -> Notification.Name {
        return Notification.Name.init("SC_N_newCreditCardAdded")
    }
    
    class func removeCreditCard() -> Notification.Name {
        return Notification.Name.init("SC_N_removeCreditCard")
    }
    
    /// 本周期结算完成
    class func settleSuccess() -> Notification.Name {
        return Notification.Name.init("SC_N_settleSuccess")
    }
    
    /// 刷卡
    class func payActionSuccess() -> Notification.Name {
        return Notification.Name.init("SC_N_payActionSuccess")
    }
    
    /// 还款
    class func repaymentSuccess() -> Notification.Name {
        return Notification.Name.init("SC_N_payActionSuccess")
    }
    
    /// 设置了新头像
    class func postaritUpdated() -> Notification.Name {
        return Notification.Name.init("SC_N_postraitUpdated")
    }
}
