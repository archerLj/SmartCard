//
//  SCNotificationNames.swift
//  SmartCard
//
//  Created by archerLj on 2018/12/6.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation

class SCNotificationName {
    
    /// 信用卡变动
    class func creditCardModified() -> Notification.Name {
        return Notification.Name.init("SC_N_creditCardModified")
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
    
    /// 更新了个人信息
    class func profileUpdated() -> Notification.Name {
        return Notification.Name.init("SC_N_profileUpdated")
    }
}
