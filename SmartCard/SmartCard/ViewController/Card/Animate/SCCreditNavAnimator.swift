//
//  SCCreditNavAnimator.swift
//  SmartCard
//
//  Created by archerLj on 2018/12/3.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import UIKit

class SCCreditNavAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    let animationDuration = 0.3
    var operation: UINavigationController.Operation = .push
    var originFrame = CGRect.zero
    weak var storedContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        storedContext = transitionContext
        
        let originaCenter = CGPoint(x: originFrame.origin.x + originFrame.width/2, y: originFrame.origin.y + originFrame.height/2)
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        let screenRadi = sqrt(screenW * screenW + screenH * screenH)
        let originRadi = sqrt(originFrame.width * originFrame.width + originFrame.height * originFrame.height)/2
        
        
        if operation == .push {
            
            let scale = screenRadi / originRadi
            
            let toVC = transitionContext.viewController(forKey: .to) as! SCCardDetailViewController
            transitionContext.containerView.addSubview(toVC.view)
            toVC.view.frame = transitionContext.finalFrame(for: toVC)
            
            let animation = CABasicAnimation(keyPath: "transform")
            animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
            animation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(scale, scale, 1.0))
            animation.duration = animationDuration
            animation.delegate = self
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            
            let maskLayer = CAShapeLayer()
            maskLayer.isGeometryFlipped = true
            maskLayer.path = UIBezierPath(ovalIn: originFrame).cgPath
            maskLayer.bounds = (maskLayer.path?.boundingBox)!
            maskLayer.position = originaCenter
            toVC.view.layer.mask = maskLayer
            maskLayer.add(animation, forKey: nil)
            
//            let fadeIn = CABasicAnimation(keyPath: "opacity")
//            fadeIn.fromValue = 0.0
//            fadeIn.toValue = 1.0
//            fadeIn.duration = animationDuration
//            toVC.view.layer.add(fadeIn, forKey: nil)
            
        } else {
            let originScale = screenRadi / originRadi
            let scale = originRadi / screenRadi
            let fromVC = transitionContext.viewController(forKey: .from) as! SCCardDetailViewController
            let fromView = transitionContext.view(forKey: .from)!
            let toView = transitionContext.view(forKey: .to)!
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            
            let animation = CABasicAnimation(keyPath: "transform")
            animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
            animation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(scale, scale, 1.0))
            animation.duration = animationDuration
            animation.delegate = self
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
            
            let maskRect = CGRect(x: 0, y: 0, width: originFrame.width * originScale, height: originFrame.height * originScale)
            let maskLayer = CAShapeLayer()
            maskLayer.isGeometryFlipped = true
            maskLayer.path = UIBezierPath(ovalIn: maskRect).cgPath
            maskLayer.bounds = (maskLayer.path?.boundingBox)!
            maskLayer.position = originaCenter
            fromVC.view.layer.mask = maskLayer
            maskLayer.add(animation, forKey: nil)
            
//            let fadeOut = CABasicAnimation(keyPath: "opacity")
//            fadeOut.fromValue = 1.0
//            fadeOut.toValue = 0.0
//            fadeOut.duration = animationDuration
//            fromVC.view.layer.add(fadeOut, forKey: nil)
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let context = storedContext {
            context.completeTransition(!context.transitionWasCancelled)
            let vc = context.viewController(forKey: operation == .push ? .to : .from)!
            vc.view.layer.mask = nil
        }
        storedContext = nil
    }
}
