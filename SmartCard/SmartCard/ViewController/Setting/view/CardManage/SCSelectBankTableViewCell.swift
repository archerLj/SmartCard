//
//  SCSelectBankTableViewCell.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/21.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCSelectBankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
