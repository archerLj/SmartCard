//
//  SCGestureView.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/29.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit
import AudioToolbox

class SCGestureView: UIView {
    
    @IBInspectable
    var normalItemImage: UIImage!
    @IBInspectable
    var selectedItemImage: UIImage!
    @IBInspectable
    var errorItemImage: UIImage!
    @IBInspectable
    var connectLineColor: UIColor!
    @IBInspectable
    var errorColor: UIColor!
    @IBInspectable
    var connectLineWidth: CGFloat = 0
    @IBInspectable
    var itemWHPercentInParentView: CGFloat = 0
    
    var resultAction: ((String) -> Void)?
    var startAction: (() -> Void)?
    
    var isError = false
    fileprivate var allItems: [UIImageView] = []
    fileprivate var endPoint: CGPoint?
    fileprivate var itemsSelected: [UIImageView] = []
    var resultSequence: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initSetting()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for item in allItems {
            if let point = touches.first?.location(in: self) {
                if item.frame.contains(point) {
                    if let startAction = startAction {
                        startAction()
                    }
                    item.image = selectedItemImage
                    itemsSelected.append(item)
                    playSound()
                    break
                }
            }
        }
    }
    
    func playSound() {
//        let impactFeedBack = UIImpactFeedbackGenerator(style: .heavy)
//        impactFeedBack.prepare()
//        impactFeedBack.impactOccurred()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for item in allItems {
            if let point = touches.first?.location(in: self) {

                if item.frame.contains(point) && !itemsSelected.contains(item) {
                    item.image = selectedItemImage
                    itemsSelected.append(item)
                    playSound()
                    break
                }
                
                endPoint = point
                setNeedsDisplay()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        endPoint = nil
        setNeedsDisplay()
        setResult()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        endPoint = nil
        setNeedsDisplay()
        setResult()
    }
    
    func setResult() {
        self.isUserInteractionEnabled = false
        for item in itemsSelected {
            resultSequence += String(item.tag)
        }
        
        if let resultAction = resultAction {
            resultAction(resultSequence)
        }
    }
    
    func reset(useable: Bool = true) {
        
        for item in allItems {
            item.image = normalItemImage
        }
        
        isError = false
        resultSequence = ""
        itemsSelected.removeAll()
        setNeedsDisplay()
        self.isUserInteractionEnabled = useable
    }
    
    func showError() {
        isError = true
        setNeedsDisplay()
    }
    
    func initSetting() {
        if itemWHPercentInParentView > 1/3 {
            fatalError("itemWHPercentInParentView shouldn't beyoned 1/3.")
        }
        
        let boundsW = self.bounds.width
        let boundsH = self.bounds.height
        let itemWH = min(boundsW, boundsH) * itemWHPercentInParentView
        let gap = (min(boundsW, boundsH) - itemWH * 3) / 2
        let startX = boundsW > boundsH ? (boundsW - boundsH) / 2 : 0
        let startY = boundsH > boundsW ? (boundsH - boundsW) / 2 : 0
        
        
        for row in 0 ..< 3 {
            for column in 0 ..< 3 {
                let itemImageView = UIImageView(frame: CGRect(x: CGFloat(column) * (itemWH + gap) + startX,
                                                              y: CGFloat(row) * (itemWH + gap) + startY,
                                                              width: itemWH,
                                                              height: itemWH))
                itemImageView.contentMode = .scaleAspectFit
                let tag = row * 3 + column
                itemImageView.tag = tag
                itemImageView.image = normalItemImage
                self.addSubview(itemImageView)
                allItems.append(itemImageView)
            }
        }
    }

    override func draw(_ rect: CGRect) {
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(connectLineWidth)
            if isError {
                for item in itemsSelected {
                    item.image = errorItemImage
                }
                context.setStrokeColor(errorColor.cgColor)
            } else {
                context.setStrokeColor(connectLineColor.cgColor)
            }
            
            if itemsSelected.count > 0 {
                let first = itemsSelected.first!
                context.move(to: first.center)
            }
            
            let lastImtes = itemsSelected.dropFirst()
            if itemsSelected.count > 1 {
                for item in lastImtes {
                    context.addLine(to: item.center)
                }
            }
            
            if let endPoint = endPoint {
                context.addLine(to: endPoint)
            }
            
            context.strokePath()
        }
    }
}
