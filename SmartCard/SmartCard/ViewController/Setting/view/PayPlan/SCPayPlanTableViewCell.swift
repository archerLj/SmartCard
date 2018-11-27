//
//  SCPayPlanTableViewCell.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/27.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCPayPlanTableViewCell: UITableViewCell {
    
    static let sNotificationName = "SCPayPlanTableViewCellNotification.Name"
    
    @IBOutlet weak var tVerticalLine: UIView!
    @IBOutlet weak var bVerticalLine: UIView!
    @IBOutlet weak var hourRange: UILabel!
    @IBOutlet weak var more: UIImageView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var editBtnTopConstraint: NSLayoutConstraint!
    var sellerNameViews: [UIView] = []
    var payRangeViews: [UIView] = []
    
    var deleteCell: (() -> Void)?
    var edit: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        hideActionBtns(animate: false)
        NotificationCenter.default.addObserver(self, selector: #selector(reciveNotification(notification:)), name: NSNotification.Name(rawValue: SCPayPlanTableViewCell.sNotificationName), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reciveNotification(notification: Notification) {
        let userInfo = notification.userInfo
        if let y = userInfo?["cellCenterY"] as? CGFloat {
            if y == self.center.y {
                return
            }
        }
        
        hideActionBtns(animate: false)
    }
    
    @IBAction func showActions(_ sender: UIButton) {
        showActionBtns()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SCPayPlanTableViewCell.sNotificationName), object: nil, userInfo: ["cellCenterY": self.center.y])
    }
    
    func showActionBtns() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [], animations: {
            self.deleteView.alpha = 1
            self.deleteViewTopConstraint.constant = 0
            self.contentView.layoutIfNeeded()
        }, completion: { _ in
            self.deleteView.isHidden = false
        })
        
        UIView.animate(withDuration: 0.1, delay: 0.05,  options: [], animations: {
            self.editBtn.alpha = 1.0
            self.editBtnTopConstraint.constant = 47
            self.contentView.layoutIfNeeded()
        }) { _ in
            self.editBtn.isHidden = false
        }
    }
    
    func hideActionBtns(animate: Bool) {
        if animate {
            UIView.animate(withDuration: 0.1, animations: {
                self.editBtn.alpha = 0
                self.editBtnTopConstraint.constant = 0
                self.contentView.layoutIfNeeded()
            }) { _ in
                self.editBtn.isHidden = true
            }
            
            UIView.animate(withDuration: 0.1, delay: 0.05, options: [], animations: {
                self.deleteView.alpha = 0
                self.deleteViewTopConstraint.constant = -20
                self.contentView.layoutIfNeeded()
            }, completion: { _ in
                self.deleteView.isHidden = true
            })
            
        } else {
            self.editBtn.isHidden = true
            self.editBtnTopConstraint.constant = 0
            self.deleteView.isHidden = true
            self.deleteViewTopConstraint.constant = -20
            self.contentView.layoutIfNeeded()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reset() {
        for sellerName in sellerNameViews {
            sellerName.removeFromSuperview()
        }
        for payRange in payRangeViews {
            payRange.removeFromSuperview()
        }
        sellerNameViews.removeAll()
        payRangeViews.removeAll()
        
        self.tVerticalLine.isHidden = false
        self.bVerticalLine.isHidden = false
        
        hideActionBtns(animate: false)
    }
    
    func configure(payPlan: PayPlan, sellerConfigures: [SellerConfigure]) {
        
        reset()
        
        self.hourRange.text = String(payPlan.startHour) + "点 ~ " + String(payPlan.endHour) + "点"
        
        var bottom = self.hourRange.frame.maxY + 10
        let left = self.hourRange.frame.minX
        
        for sellerConfigure in sellerConfigures {
            
            let sellerName = UILabel(frame: CGRect(x: left, y: bottom + 10.0, width: 100.0, height: 30.0))
            let payRange = UILabel(frame: CGRect(x: sellerName.frame.maxX + 10, y: bottom + 10, width: self.contentView.bounds.width - sellerName.frame.maxX - 10 , height: 30.0))
            
            sellerName.textColor = UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)
            payRange.textColor = UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)
            
            sellerName.text = sellerConfigure.sellerName
            payRange.text = "(" + String(sellerConfigure.minPay) + "~" + String(sellerConfigure.maxPay) + ")元"
            
            self.contentView.addSubview(sellerName)
            self.contentView.addSubview(payRange)
            
            bottom = sellerName.frame.maxY
            sellerNameViews.append(sellerName)
            payRangeViews.append(payRange)
        }
        
        self.contentView.layoutIfNeeded()
    }

    @IBAction func deleteAction(_ sender: UIButton) {
        hideActionBtns(animate: true)
        if let deleteCell = deleteCell {
            delay(0.5) {
                deleteCell()
            }
        }
    }
    
    @IBAction func editAction(_ sender: Any) {
        hideActionBtns(animate: true)
        if let edit = edit {
            delay(0.5) {            
                edit()
            }
        }
    }
    
    func firstCellConfigure() {
        self.tVerticalLine.isHidden = true
    }
    
    func lastCellConfigure() {
        self.bVerticalLine.isHidden = true
    }
}
