//
//  SCHistoryTableViewCell.swift
//  SmartCard
//
//  Created by archerLj on 2018/12/7.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var seller: UILabel!
    @IBOutlet weak var payNum: UILabel!
    @IBOutlet weak var time: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(payRecord: PayRecord) {
        seller.text = payRecord.sellerName
        payNum.text = String(payRecord.payNum).getFormatNumber()

        let f1 = payRecord.payDate!.dropFirst(11)
        let f2 = f1.dropLast(3)
        time.text = String(f2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
