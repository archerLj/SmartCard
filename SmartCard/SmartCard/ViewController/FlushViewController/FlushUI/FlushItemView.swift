//
//  FlushItemView.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/13.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class FlushItemView: UIView {
    static var flushItem: UIImage!
    static let rippleAnimationKeyTimes = [0, 0.61, 0.7, 0.887, 1]
    let kAnimationTimeOffset: CFTimeInterval = 0.35 * 3.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.contents = FlushItemView.flushItem.cgImage
        layer.shouldRasterize = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    convenience init(itemFileName: String) {
        FlushItemView.flushItem = UIImage(named: itemFileName, in: Bundle(identifier: "com.lj0011977"), compatibleWith: nil)
        self.init(frame: CGRect.zero)
//        frame = CGRect(x: 0, y: 0, width: FlushItemView.flushItem.size.width, height: FlushItemView.flushItem.size.height)
        frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
    }
    
    func startAnimationWithDuration(_ duration: TimeInterval, beginTime: TimeInterval, rippleDelay: TimeInterval, rippleOffset: CGPoint) {
        
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0, 0.2, 1)
        let linearFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        let easeOutFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        let easeInOutFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        let zeroPointValue = NSValue(cgPoint: CGPoint.zero)
        var animations = [CAAnimation]()
        
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.values = [1, 1, 1.05, 1, 1]
        scaleAnimation.keyTimes = FlushItemView.rippleAnimationKeyTimes as [NSNumber]
        scaleAnimation.timingFunctions = [linearFunction, timingFunction, timingFunction, linearFunction]
        scaleAnimation.beginTime = 0.0
        scaleAnimation.duration = duration
        animations.append(scaleAnimation)
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration = duration
        positionAnimation.timingFunctions = [linearFunction, timingFunction, timingFunction, linearFunction]
        positionAnimation.keyTimes = FlushItemView.rippleAnimationKeyTimes as [NSNumber]
        positionAnimation.values = [zeroPointValue, zeroPointValue, NSValue(cgPoint: rippleOffset), zeroPointValue, zeroPointValue]
        positionAnimation.isAdditive = true
        animations.append(positionAnimation)
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = duration
        opacityAnimation.timingFunctions = [easeInOutFunction, timingFunction, timingFunction, easeOutFunction, linearFunction]
        opacityAnimation.keyTimes = [0.0, 0.61, 0.7, 0.767, 0.95, 1.0]
        opacityAnimation.values = [0.0, 1.0, 0.45, 0.6, 0.0, 0.0]
        animations.append(opacityAnimation)
        
        let group = CAAnimationGroup()
        group.repeatCount = .infinity
        group.fillMode = CAMediaTimingFillMode.backwards
        group.duration = duration
        group.beginTime = beginTime + rippleDelay
        group.isRemovedOnCompletion = false
        group.animations = animations
        group.timeOffset = kAnimationTimeOffset
        
        layer.add(group, forKey: nil)
    }
}
