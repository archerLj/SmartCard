//
//  FlushGridView.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/13.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class FlushGridView: UIView {
    fileprivate var containerView: UIView!
    fileprivate var modelView: FlushItemView!
    fileprivate var centerItemView: FlushItemView!
    fileprivate var numberOfRows = 0
    fileprivate var numberOfColumns = 0
    
    fileprivate var itemViews: [[FlushItemView]] = []
    fileprivate var beginTime: CFTimeInterval = 0
    fileprivate let kRippleDelayMultiplier: TimeInterval = 0.000666
    let kRippleMagnitudeMultiplier: CGFloat = 0.025
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been completed.")
    }
    
    init(itemFileName: String, frame: CGRect) {
        modelView = FlushItemView(itemFileName: itemFileName)
        super.init(frame: frame)
        clipsToBounds = true
        layer.masksToBounds = true
        
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width * 1.4, height: frame.size.height * 1.4))
        containerView.backgroundColor = UIColor.appColor
        addSubview(containerView)
        
        renderItemViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.center = center
    }
    
    func startAnimting() {
        beginTime = CACurrentMediaTime()
        startAnimatingWithBeginTime(beginTime)
    }
}

extension FlushGridView {
    fileprivate func renderItemViews() {
        let containerWidth = containerView.bounds.width
        let containerHeight = containerView.bounds.height
        
        let modelWidth = modelView.bounds.width
        let modelHeight = modelView.bounds.height
        
        numberOfColumns = Int(ceil(containerWidth / modelWidth))
        numberOfRows = Int(ceil(containerHeight / modelHeight))
        
        for y in 0..<numberOfRows {
            
            var itemRows: [FlushItemView] = []
            
            for x in 0..<numberOfColumns {
                let view = FlushItemView()
                view.frame = CGRect(x: CGFloat(x) * modelWidth, y: CGFloat(y) * modelHeight, width: modelWidth, height: modelHeight)
                containerView.addSubview(view)
                itemRows.append(view)
                
                if view.frame.contains(center) {
                    centerItemView = view
                }
            }
            
            itemViews.append(itemRows)
        }
    }
    
    fileprivate func startAnimatingWithBeginTime(_ beginTime: TimeInterval) {
        let linearTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        let keyFrame = CAKeyframeAnimation(keyPath: "transform.scale")
        keyFrame.timingFunctions = [linearTimingFunction, CAMediaTimingFunction(controlPoints: 0.6, 0.0, 0.15, 0.1), linearTimingFunction]
        keyFrame.repeatCount = .infinity
        keyFrame.duration = kAnimationDuration
        keyFrame.isRemovedOnCompletion = false
        keyFrame.keyTimes = [0.0, 0.45, 0.887, 1.0]
        keyFrame.values = [0.75, 0.75, 1.0, 1.0]
        keyFrame.beginTime = beginTime
        keyFrame.timeOffset = kAnimationTimeOffset
        
        containerView.layer.add(keyFrame, forKey: "scale")
        
        for itemRows in itemViews {
            for itemView in itemRows {
                let distance = distanceFromCenterViewWithView(view: itemView)
                var vector = self.normalizedVectorFromCenterViewToView(view: itemView)
                
                vector = CGPoint(x: vector.x * kRippleMagnitudeMultiplier * distance, y: vector.y * kRippleMagnitudeMultiplier * distance)
                itemView.startAnimationWithDuration(kAnimationDuration, beginTime: beginTime, rippleDelay: kRippleDelayMultiplier * TimeInterval(distance), rippleOffset: vector)
            }
        }
    }
    
    fileprivate func distanceFromCenterViewWithView(view: UIView) -> CGFloat {

        let normalizedX = view.center.x - centerItemView.center.x
        let normalizedY = view.center.y - centerItemView.center.y
        return sqrt(normalizedX * normalizedX + normalizedY * normalizedY)
    }
    
    fileprivate func normalizedVectorFromCenterViewToView(view: UIView) -> CGPoint {
        
        let length = distanceFromCenterViewWithView(view: view)
        guard length != 0 else {
            return CGPoint.zero
        }
        
        let deltaX = view.center.x - centerItemView.center.x
        let deltaY = view.center.y - centerItemView.center.y
        return CGPoint(x: deltaX / length, y: deltaY / length)
    }
}
