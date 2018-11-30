//
//  SCProfileTableViewCell3.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/27.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCProfileTableViewCell3: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    var switchAction:( (Bool) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        switcher.addTarget(self, action: #selector(switchAction(sender:)), for: .touchUpInside)
    }
    
    @objc func switchAction(sender: UISwitch) {
        if let switchAction = switchAction {
            switchAction(sender.isOn)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
