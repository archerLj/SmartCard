//
//  SCProfileTableViewCell1.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/27.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCProfileTableViewCell1: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var nickName: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nickName.layer.borderColor = UIColor.white.cgColor
        nickName.layer.borderWidth = 3.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
