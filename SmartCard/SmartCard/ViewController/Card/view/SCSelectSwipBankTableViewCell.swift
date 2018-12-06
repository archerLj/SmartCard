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
    @IBOutlet weak var checkedFlag: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(bankIndex: Int16, checked: Bool) {
        let index = Int(bankIndex)
        self.bankName.text = SCBank.Names[index]
        self.bankIcon.image = SCBank.Icons[index]
        checkedFlag.isHidden = !checked
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
