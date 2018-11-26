//
//  SCPayARateCellContent.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/26.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCPayARateCellContent: UIView {
    
    @IBOutlet weak var contaienr: UIView!
    @IBOutlet weak var payWay: UILabel!
    @IBOutlet weak var rate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contaienr.layer.cornerRadius = 10.0
    }
    
    func configure(payWayARate: PayWayARate) {
        payWay.text = payWayARate.payWay
        rate.text = String(payWayARate.rate) + "%"
    }
}
