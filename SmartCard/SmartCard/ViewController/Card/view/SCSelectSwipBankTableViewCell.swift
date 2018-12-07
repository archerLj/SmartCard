//
//  SCSelectSwipBankTableViewCell.swift
//  SmartCard
//
//  Created by archerLj on 2018/12/3.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCSelectSwipBankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bankIcon: UIImageView!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var payNumsOfToday: UILabel!
    @IBOutlet weak var checkedFlag: UIImageView!
    var textOriginalColor: UIColor!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        textOriginalColor = payNumsOfToday.textColor
    }
    
    func configure(bankIndex: Int16, checked: Bool, payNumsOfToday: Float?) {
        let index = Int(bankIndex)
        self.bankName.text = SCBank.Names[index]
        self.bankIcon.image = SCBank.Icons[index]
        checkedFlag.isHidden = !checked
        
        if let num = payNumsOfToday {
            self.payNumsOfToday.textColor = textOriginalColor
            if num > 0 {
                self.payNumsOfToday.text = "(今日已刷\(num))"
            } else {
                self.payNumsOfToday.text = nil
            }
        } else {
            self.payNumsOfToday.text = "(获取今日刷卡记录失败)"
            self.payNumsOfToday.textColor = UIColor.red
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
