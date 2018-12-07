//
//  SCPasswdLoginViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/29.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCPasswdLoginViewController: UIViewController {
    
    @IBOutlet weak var postrait: UIImageView!
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginbtn: UIButton!
    var userInfo: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        postrait.layer.cornerRadius = postrait.bounds.width/2
        postrait.clipsToBounds = true
        self.navigationController?.delegate = self
        adapteKeyboard = true
        self.account.layer.borderWidth = 3.0
        self.account.layer.borderColor = UIColor.white.cgColor
        self.password.layer.borderColor = UIColor.white.cgColor
        self.password.layer.borderWidth = 3.0
        self.loginbtn.layer.cornerRadius = 5.0
        
        if let userInfo = userInfo {
            account.text = userInfo.account
            if let p = userInfo.postrait {
                postrait.image = UIImage(data: p)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction
    func login(sender: UIButton) {
        guard let account = account.text, !account.isEmpty else {
            showErrorHud(title: "账号不合法")
            return
        }
        
        guard let pwd = password.text, !pwd.isEmpty else {
            showErrorHud(title: "密码不合法")
            return
        }
        
        if let user = UserManager.isUserOrPwdPassed(account: account, pwd: pwd) {
            AppDelegate.currentUser.value = user
            let mainVC = SCMainTabBarViewController()
            UIApplication.shared.keyWindow?.rootViewController = mainVC
        } else {
            showErrorHud(title: "账号和密码不匹配")
        }
    }
    
    @IBAction
    func register(sender: UIButton) {
        let registerVC: SCRegisterViewController = UIStoryboard.storyboard(storyboard: .Login).initViewController()
        _ = registerVC.accountOb.subscribe(onNext: { account in
            self.account.text = account
        })
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
}

extension SCPasswdLoginViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
}
