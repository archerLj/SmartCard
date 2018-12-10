//
//  SCCreditCardTopView.swift
//  SmartCard
//
//  Created by archerLj on 2018/12/6.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCCreditCardTopView: UIView {
    @IBOutlet weak var lastSettlePayNum: UILabel!
    @IBOutlet weak var thisSettlePayNum: UILabel!
    @IBOutlet weak var lastSettleCharge: UILabel!
    @IBOutlet weak var thisSettleCharge: UILabel!
    
    func configure(lastSettlePayNum: Float,
                   lastSettleCharge: Float,
                   thisSettlePayNum: Float,
                   thisSettleCharge: Float) {
        self.lastSettlePayNum.text = "上期刷卡量：\(String(lastSettlePayNum).getFormatNumber())"
        self.lastSettleCharge.text = "(手续费\(String(lastSettleCharge).getFormatNumber()))"
        self.thisSettlePayNum.text = "本期刷卡量：\(String(thisSettlePayNum).getFormatNumber())"
        self.thisSettleCharge.text = "(手续费\(String(thisSettleCharge).getFormatNumber()))"
    }
}
