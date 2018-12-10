//
//  SCCreditCardTableViewCell.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/30.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCCreditCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconBgView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var bankName: UILabel!
    /// 额度
    @IBOutlet weak var creditLines: UILabel!
    /// 已刷额度
    @IBOutlet weak var creditLayOut: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.cornerRadius = 10.0
        iconBgView.layer.cornerRadius = iconBgView.bounds.width/2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(cardInfo: CardInfo,
                   cardPayACharges: (lastPayNum: Float, lastCharge: Float, unSettledPayNum: Float, unSettledCharges: Float)) {
        let index = Int(cardInfo.bankID)
        icon.image = SCBank.Icons[index]
        bankName.text = SCBank.Names[index]
        bgView.backgroundColor = SCBank.Colors[index]
        creditLines.text = String(cardInfo.creditLines).getFormatNumber()
        creditLayOut.text = String(cardPayACharges.unSettledPayNum).getFormatNumber()
    }
}
