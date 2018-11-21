//
//  SCSettingTableViewCell.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/20.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCSettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
