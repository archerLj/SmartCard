//
//  SCGestureLoginViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/29.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCGestureLoginViewController: UIViewController {
    
    private let sRetryCount = 3
    @IBOutlet weak var postrait: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var gestureView: SCGestureView!
    var retryCount = 0
    var timer: SCTimer?
    var userInfo: User?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        postrait.layer.cornerRadius = postrait.bounds.width/2
        postrait.clipsToBounds = true
        gestrueVerify()
        if let user = userInfo {
            nickName.text = user.account
            if let p = user.postrait {
                postrait.image = UIImage(data: p)
            }
        }
    }
    
    func gestrueVerify() {
        gestureView.startAction = {
            self.retryCount += 1
            self.infoLabel.text = "完成后松开手指"
            self.infoLabel.textColor = UIColor.gray
        }
        
        gestureView.resultAction = { result in
            if let user = UserManager.getUserBy(gesture: result) {
                AppDelegate.currentUser.value = user
                let mainVC = SCMainTabBarViewController()
                UIApplication.shared.keyWindow?.rootViewController = mainVC
                
            } else {
                self.gestureView.showError()
                if self.retryCount > self.sRetryCount {
                    self.gestureView.reset(useable: false)
                    self.infoLabel.text = "错误次数太多，请23秒后重试"
                    
                    var count = 23
                    self.timer = SCTimer.repeatingTimer(timeInterval: 23, block: {
                        count -= 1
                        if count == 0 {
                            self.infoLabel.text = "请输入手势密码"
                            self.infoLabel.textColor = UIColor.gray
                            self.timer = nil
                            self.retryCount = 0
                            self.gestureView.reset()
                        } else {
                            self.infoLabel.text = "错误次数太多，请\(count)秒后重试"
                        }
                    })
                } else {
                    self.infoLabel.text = "密码错误，请重试"
                    self.gestureView.reset()
                }
                
                self.infoLabel.textColor = UIColor.red
                self.infoLabel.transform = CGAffineTransform(translationX: -20, y: 0)
                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 20, options: .curveEaseInOut, animations: {
                    self.infoLabel.transform = .identity
                }, completion: nil)
            }
        }
    }
    
    @IBAction
    func passwordLogin(sender: UIButton) {
        let passwordLoginVC: SCPasswdLoginViewController = UIStoryboard.storyboard(storyboard: .Login).initViewController()
        let navVC = UINavigationController(rootViewController: passwordLoginVC)
        self.present(navVC, animated: true, completion: nil)
    }
}
