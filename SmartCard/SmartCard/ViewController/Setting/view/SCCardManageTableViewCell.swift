//
//  SCCardManageTableViewCell.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/20.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCCardManageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var imagBgContainer: UIView!
    @IBOutlet weak var bankIcon: UIImageView!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var cardNum: UILabel!
    var shadowView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        container.layer.cornerRadius = 5.0
        container.clipsToBounds = true
        imagBgContainer.layer.cornerRadius = imagBgContainer.bounds.height/2.0
        imagBgContainer.clipsToBounds = true
        
        shadowView = UIView(frame: container.frame)
        shadowView.clipsToBounds = false
        let layer = shadowView.layer
        layer.masksToBounds = false
        layer.shadowOpacity = 0.8
        
        let rect = shadowView.bounds
        layer.shadowPath = CGPath(rect: CGRect(x: rect.origin.x + 5.0, y: rect.origin.y + 7.0, width: rect.width, height: rect.height), transform: nil)
        
        container.superview?.insertSubview(shadowView, belowSubview: container)
        shadowView.addSubview(container)
    }
    
    func configuer(bankIcon icon: UIImage, bankName: String, cardNum: String, bankTheme: UIColor) {
        self.bankIcon.image = icon
        self.bankName.text = bankName
        self.cardNum.text = String(cardNum.dropFirst(cardNum.count - 4))
        self.container.backgroundColor = bankTheme
        self.shadowView.layer.shadowColor = bankTheme.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func copyCardNum(_ sender: UIButton) {
    }
}
