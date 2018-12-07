//
//  SCEmptyGuideView.swift
//  SmartCard
//
//  Created by archerLj on 2018/12/7.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCEmptyGuideView: UIView {
    
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var subTitleLabel: UILabel!
    static var showingArr = [SCEmptyGuideView]()
    
    class func newOne() -> SCEmptyGuideView {
        return SCEmptyGuideView()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
        titleLabel.numberOfLines = 0
        self.addSubview(titleLabel)
        
        subTitleLabel = UILabel(frame: CGRect.zero)
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel.textColor = UIColor(white: 0.9, alpha: 1.0)
        subTitleLabel.numberOfLines = 0
        self.addSubview(subTitleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(in parentView: UIView, infoImage image: UIImage, infoTitle title: String? = nil, subInfoTitle subTitle: String? = nil) {
        
        SCEmptyGuideView.showingArr.append(self)
        parentView.addSubview(self)
        imageView.image = image
        titleLabel.text = title
        subTitleLabel.text = subTitle
        self.frame = parentView.bounds
    }
    
    class func dismiss(from parentView: UIView) {
        for emptyView in SCEmptyGuideView.showingArr {
            if emptyView.superview === parentView {
                emptyView.removeFromSuperview()
                SCEmptyGuideView.showingArr.removeAll(where: { $0 === emptyView })
                break
            }
        }
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        
        let imageViewWH:CGFloat = 200
        imageView.frame = CGRect(x: 0, y: 0, width: imageViewWH, height: imageViewWH)
        imageView.center = CGPoint(x: self.center.x, y: self.center.y - imageViewWH/2)
        titleLabel.frame = CGRect(x: 20, y: imageView.frame.maxY + 10, width: self.bounds.width - 40, height: 40)
        subTitleLabel.frame = CGRect(x: 20, y: titleLabel.frame.maxY + 5, width: self.bounds.width, height: 40)
    }
}
