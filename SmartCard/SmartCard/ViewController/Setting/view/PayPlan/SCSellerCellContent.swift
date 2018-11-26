//
//  SCSellerCellContent.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/26.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCSellerCellContent: UITableViewCell {
    
    @IBOutlet weak var sellerName: UILabel!
    @IBOutlet weak var payRange: UILabel!
    @IBOutlet weak var container: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        container.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(sellerConfigure: SellerConfigure) {
        self.sellerName.text = sellerConfigure.sellerName
        self.payRange.text = "(" + String(sellerConfigure.minPay) + " ~ " + String(sellerConfigure.maxPay) + ")元"
    }
}
