//
//  LogoView.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/13.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class LogoView: UIView {
    
    let grandientLayer : CAGradientLayer = {
        
        let grandientLayer = CAGradientLayer()
        grandientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        grandientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        grandientLayer.colors = [
            UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0).cgColor,
            UIColor(red: 1/255.0, green: 39/255.0, blue: 164/255.0, alpha: 1.0).cgColor,
            UIColor(red: 101/255.0, green: 137/255.0, blue: 1.0, alpha: 1.0).cgColor
        ]

        grandientLayer.locations = [0.0, 0.5, 1.0]
        
        return grandientLayer
    }()
    
    var maskImage: UIImage! {
        didSet {
            
            setNeedsDisplay()
            
            let maskLayer = CALayer()
            maskLayer.frame = bounds
            maskLayer.contents = maskImage.cgImage
            maskLayer.backgroundColor = UIColor.clear.cgColor
            
            grandientLayer.mask = maskLayer
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        grandientLayer.frame = bounds
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        layer.addSublayer(grandientLayer)
        
        let grandientAnimation = CABasicAnimation(keyPath: "locations")
        grandientAnimation.fromValue = [0.0, 0.0, 0.25]
        grandientAnimation.toValue = [0.65, 0.95, 1.0]
        grandientAnimation.duration = kAnimationDuration * 0.8
        grandientAnimation.repeatCount = .infinity
        grandientLayer.add(grandientAnimation, forKey: nil)
    }
}
