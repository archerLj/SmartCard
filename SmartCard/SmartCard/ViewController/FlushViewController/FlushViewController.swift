//
//  FlushViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/13.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class FlushViewController: UIViewController {
    
    var flushGridView: FlushGridView!
//    var logoView: LogoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        flushGridView = FlushGridView(itemFileName: "flush_item", frame: view.bounds)
        view.addSubview(flushGridView)
        flushGridView.startAnimting()
        
        let logoImage = UIImage(named: "appIcon_smart")!
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.frame = CGRect(x: 0, y: 0, width: logoImage.size.width, height: logoImage.size.height)
        view.addSubview(logoImageView)
        logoImageView.center = CGPoint(x: view.center.x, y: view.center.y - 50.0)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let user = AppDelegate.getLastUserInfo()
        
        if let gesture = user?.gestureSequence, !gesture.isEmpty {
            
            let gestrueLoginVC: SCGestureLoginViewController = UIStoryboard.storyboard(storyboard: .Login).initViewController()
            gestrueLoginVC.userInfo = user
            UIApplication.shared.keyWindow?.rootViewController = gestrueLoginVC
            
        } else {
            let passwordLoginVC: SCPasswdLoginViewController = UIStoryboard.storyboard(storyboard: .Login).initViewController()
            passwordLoginVC.userInfo = user
            let navVC = UINavigationController(rootViewController: passwordLoginVC)
            UIApplication.shared.keyWindow?.rootViewController = navVC
        }
    }
}
