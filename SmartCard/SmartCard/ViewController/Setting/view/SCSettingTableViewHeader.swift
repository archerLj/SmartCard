//
//  SCSettingTableViewHeader.swift
//  SmartCard
//
//  Created by archerLj on 2018/12/10.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCSettingTableViewHeader: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var postraitBgView: UIView!
    @IBOutlet weak var postrait: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var brefIntroduction: UILabel!
    @IBOutlet weak var bankNums: UILabel!
    @IBOutlet weak var cardNums: UILabel!
    var postraitBtn: UIButton!
    var postraitBtnAction: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postraitBgView.layer.cornerRadius = postraitBgView.bounds.width/2
        postrait.layer.cornerRadius = postrait.bounds.width/2
        postrait.clipsToBounds = true
        postrait.contentMode = .scaleAspectFit
        postraitBgView.layer.borderColor = UIColor.init(white: 0.97, alpha: 1.0).cgColor
        postraitBgView.layer.borderWidth = 1.0
        
        postraitBtn = UIButton(frame: CGRect.zero)
        self.addSubview(postraitBtn)
        postraitBtn.addTarget(self, action: #selector(postraitAction(_:)), for: .touchUpInside)
        
        containerView.layer.shadowColor = UIColor(red: 226/255.0, green: 226/255.0, blue: 226/255.0, alpha: 1.0).cgColor
        containerView.layer.shadowOpacity = 1.0
        containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let rect = postrait.convert(postrait.frame, to: self)
        postraitBtn.frame = rect
    }
    
    @objc func postraitAction(_ sender: UIButton) {
        if let action = postraitBtnAction {
            action()
        }
    }
}
