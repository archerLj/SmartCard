//
//  SCRemoveableTableViewCell.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/23.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

protocol SCRemoveableTableViewCellDelegate {
    func SCRemoveableTableViewCell(cell: SCRemoveableTableViewCell, configureDeleteView view: UIView) -> UIView
}

class SCRemoveableTableViewCell: UITableViewCell {
    
    class MyScrollView: UIScrollView {
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            let cell = self.superview?.superview as! SCRemoveableTableViewCell
            cell.touchesBegan(touches, with: event)
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            let cell = self.superview?.superview as! SCRemoveableTableViewCell
            cell.touchesEnded(touches, with: event)
        }
    }

    static var sNotificaionName = "SCRemoveableTableViewCellHideDelete"
    static var sRemoveShowing = false
    
    @IBInspectable
    var cellContentViewXib: String!
    var cellRemoved: (() -> Void)?
    var cellContentView: UIView!
    var scrollView: UIScrollView!
    var removeView: UIView!
    var removeBtn: UIButton!
    let removeViewWidth: CGFloat = 100
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if let content = Bundle.main.loadNibNamed(cellContentViewXib, owner: nil, options: nil)?.last as? UIView {
            cellContentView = content
            initConfingure()
        } else {
            fatalError("Invalid xib in SCRemoveableTableViewCell.")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification(notification:)), name: NSNotification.Name(rawValue: SCRemoveableTableViewCell.sNotificaionName), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func getNotification(notification: Notification) {
        if let centerY = notification.userInfo?["cellCenterY"] as? CGFloat {
            if centerY == self.center.y {
                return
            }
        }
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.scrollView.contentOffset = CGPoint.zero
            SCRemoveableTableViewCell.sRemoveShowing = false
        }, completion: nil)
    }
    
    func initConfingure() {
        let contentViewWidth = contentView.bounds.width
        let contentViewHeight = contentView.bounds.height
        
        cellContentView.frame = contentView.bounds

        removeView = UIView(frame: CGRect(x: contentViewWidth, y: 0, width: removeViewWidth, height: contentViewHeight))
        removeView.backgroundColor = UIColor.red
        if let contentView = cellContentView as? SCRemoveableTableViewCellDelegate {
            removeView = contentView.SCRemoveableTableViewCell(cell: self, configureDeleteView: removeView)
        }
        
        removeBtn = UIButton(frame: removeView.bounds)
        removeBtn.setTitle("删除", for: .normal)
        removeBtn.setTitleColor(UIColor.white, for: .normal)
        removeBtn.addTarget(self, action: #selector(removeCell), for: .touchUpInside)
        removeView.addSubview(removeBtn)
        
        scrollView = MyScrollView(frame: contentView.bounds)
        scrollView.contentSize = CGSize(width: contentViewWidth + removeViewWidth, height: contentViewHeight)
        scrollView.addSubview(cellContentView)
        scrollView.addSubview(removeView)
        scrollView.delegate = self
//        scrollView.isUserInteractionEnabled = false
        scrollView.bounces = false
        contentView.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
//        contentView.addGestureRecognizer(scrollView.panGestureRecognizer)
    }
    
    @objc func removeCell() {
        if let cellRemoved = cellRemoved {
            scrollView.contentOffset = CGPoint.zero
            cellRemoved()
        } else {
            fatalError("cellRemoved closure is nil!!!")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension SCRemoveableTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SCRemoveableTableViewCell.sNotificaionName), object: nil, userInfo: ["cellCenterY": self.center.y])
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetX = scrollView.contentOffset.x > removeViewWidth / 2.0 ? removeViewWidth : 0
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
            SCRemoveableTableViewCell.sRemoveShowing = (offsetX == 0) ? false : true
        }, completion: nil)
    }
}
