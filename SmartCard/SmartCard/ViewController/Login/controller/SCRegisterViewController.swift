//
//  SCRegisterViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/29.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit
import RxSwift

class SCRegisterViewController: UIViewController {
    
    fileprivate var accountSubject = PublishSubject<String>()
    var accountOb: Observable<String> {
        return accountSubject.asObservable()
    }

    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordAgain: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册"
        
        self.account.layer.borderColor = UIColor.white.cgColor
        self.account.layer.borderWidth = 3.0
        self.password.layer.borderColor = UIColor.white.cgColor
        self.password.layer.borderWidth = 3.0
        self.passwordAgain.layer.borderColor = UIColor.white.cgColor
        self.passwordAgain.layer.borderWidth = 3.0
        self.registerBtn.layer.cornerRadius = 5.0
    }
    
    deinit {
        accountSubject.onCompleted()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction
    func register(sender: UIButton) {
        guard let account = account.text, !account.isEmpty else {
            showErrorHud(title: "账号不合法")
            return
        }
        
        guard let pwd = password.text, !password.isEditing,
            let pwdA = passwordAgain.text, !pwdA.isEmpty,
            pwd == pwdA else {
                showErrorHud(title: "密码不合法或不一致")
            return
        }
        
        if let _ = UserManager.getUser(account: account) {
            showErrorHud(title: "账户已注册")
            return
        }
        
        if UserManager.save(account: account, password: pwd) {
            accountSubject.onNext(account)
            accountSubject.onCompleted()
            showSuccessHud(title: "注册成功") {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            showErrorHud(title: "注册失败，请重试")
        }
    }
}
