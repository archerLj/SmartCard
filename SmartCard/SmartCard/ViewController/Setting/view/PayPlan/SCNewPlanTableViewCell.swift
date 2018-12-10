//
//  SCNewPlanTableViewCell.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/26.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCNewPlanTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sellerName: UILabel!
    @IBOutlet weak var payRange: UILabel!
    @IBOutlet weak var checkMakrImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(sellerConfigure: SellerConfigure) {
        if sellerConfigure.sellerName!.starts(with: "C") {
            self.sellerName.text = String((sellerConfigure.sellerName?.dropFirst())!)
            self.checkMakrImg.image = UIImage(named: "checked")
        } else {
            self.sellerName.text = sellerConfigure.sellerName
            self.checkMakrImg.image = nil
        }
        self.payRange.text = "(" + String(sellerConfigure.minPay).getFormatNumber() + " ~ " + String(sellerConfigure.maxPay).getFormatNumber() + ")元"
    }
}
