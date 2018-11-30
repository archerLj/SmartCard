//
//  SCGesturePSWDViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/29.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCGesturePSWDViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var gestureView: SCGestureView!
    var gestureSequence: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置手势密码"
        self.infoLabel.text = "请绘制解锁图案"
        self.infoLabel.textColor = UIColor.gray
        
        gestureView.startAction = {
            self.infoLabel.text = "完成后松开手指"
            self.infoLabel.textColor = UIColor.gray
        }
        gestureView.resultAction = { result in
            if let gestureSequence = self.gestureSequence {
                if result == gestureSequence {
                    // TODO 保存手势
                    if GestureManager.save(sequence: result) {
                        showSuccessHud(title: "设置成功", dismissed: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    } else {
                        showErrorHud(title: "保存手势失败，请退出重试!")
                    }
                } else {
                    self.gestureView.showError()
                    self.gestureSequence = nil
                    self.infoLabel.text = "图案不匹配"
                    self.infoLabel.textColor = UIColor.red
                    self.infoLabel.transform = CGAffineTransform(translationX: -20, y: 0)
                    UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: .curveEaseInOut, animations: {
                        self.infoLabel.transform = .identity
                    }, completion: nil)
                    
                    delay(1.0, execute: {
                        self.gestureView.reset()
                    })
                }
            } else {
                self.gestureSequence = result
                self.gestureView.reset()
                self.infoLabel.textColor = UIColor.gray
                self.infoLabel.text = "确认锁屏图案"
            }
        }
    }
}
