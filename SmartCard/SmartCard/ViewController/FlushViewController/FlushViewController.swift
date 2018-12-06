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
        
        
//        let logoImage = UIImage(named: "appIcon_smart")!
//        logoView = LogoView()
//        logoView.frame = CGRect(x: 0, y: 0, width: logoImage.size.width, height: logoImage.size.height)
//        logoView.maskImage = logoImage
//        view.addSubview(logoView)
//        logoView.center = view.center
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

        let gesture = GestureManager.get()
        if let _ = gesture {
            let gestrueLoginVC: SCGestureLoginViewController = UIStoryboard.storyboard(storyboard: .Login).initViewController()
            UIApplication.shared.keyWindow?.rootViewController = gestrueLoginVC
        } else {
            let passwordLoginVC: SCPasswdLoginViewController = UIStoryboard.storyboard(storyboard: .Login).initViewController()
            let navVC = UINavigationController(rootViewController: passwordLoginVC)
            UIApplication.shared.keyWindow?.rootViewController = navVC
        }
//        delay(4.0) {
//            if let _ = gesture {
//                let gestrueLoginVC: SCGestureLoginViewController = UIStoryboard.storyboard(storyboard: .Login).initViewController()
//                UIApplication.shared.keyWindow?.rootViewController = gestrueLoginVC
//            } else {
//                let passwordLoginVC: SCPasswdLoginViewController = UIStoryboard.storyboard(storyboard: .Login).initViewController()
//                let navVC = UINavigationController(rootViewController: passwordLoginVC)
//                UIApplication.shared.keyWindow?.rootViewController = navVC
//            }
//        }
    }
}
