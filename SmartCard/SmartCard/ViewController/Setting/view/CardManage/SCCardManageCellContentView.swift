//
//  SCCardManageCellContentView.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/23.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCCardManageCellContentView: UIView {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var imagBgContainer: UIView!
    @IBOutlet weak var bankIcon: UIImageView!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var cardNum: UILabel!
    var shadowView: UIView!
    var cardInfo: CardInfo!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewConfigure()
    }
    
    func viewConfigure() {
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
    
    func configuer(cardInfo: CardInfo) {
        
        self.cardInfo = cardInfo
        let index = Int(cardInfo.bankID)
        
        self.bankIcon.image = SCBank.Icons[index]
        self.bankName.text = SCBank.Names[index]
        self.cardNum.text = String(cardInfo.cardNumber!.dropFirst(cardInfo.cardNumber!.count - 4))
        self.container.backgroundColor = SCBank.Colors[index]
        self.shadowView.layer.shadowColor = SCBank.Colors[index].cgColor
    }
    
    @IBAction func copyCardNum(_ sender: UIButton) {
        UIPasteboard.general.string = cardInfo.cardNumber
        showSuccessHud(title: "卡号已复制到粘贴板")
    }

}

extension SCCardManageCellContentView: SCRemoveableTableViewCellDelegate {
    func SCRemoveableTableViewCell(cell: SCRemoveableTableViewCell, configureDeleteView view: UIView) -> UIView {
        let frame = view.frame
        view.frame = CGRect(x: frame.origin.x, y: frame.origin.y + 10.0, width: frame.width, height: frame.height - 20.0)
        view.layer.cornerRadius = 5.0
        return view
    }
}
