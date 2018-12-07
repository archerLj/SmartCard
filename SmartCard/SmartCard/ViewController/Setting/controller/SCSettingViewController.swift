//
//  SCSettingViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/19.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCSettingViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    var postrait: UIButton!
    let cellImages = [
        UIImage(named: "card_manage"),
        UIImage(named: "swing_card_plan"),
        UIImage(named: "pay_and_rate"),
        UIImage(named: "consume_out_app")
    ]
    let cellTitles = ["信用卡管理","刷卡计划","支付方式及费率","app外刷卡登记"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        
        tableViewHeaderSetting()
        tableViewFooterSetting()
        NotificationCenter.default.addObserver(self, selector: #selector(postraitUpdated(notification:)), name: SCNotificationName.postaritUpdated(), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func postraitUpdated(notification: Notification? = nil) {
        if let postraitData = AppDelegate.currentUser.value?.postrait {
            if let image = UIImage(data: postraitData) {
                postrait.setImage(image, for: .normal)
            }
        }
    }
    
    func tableViewFooterSetting() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150.0))
        let logoutBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100.0, height: 50.0))
        
        logoutBtn.setTitle("退出登录", for: .normal)
        logoutBtn.setTitleColor(UIColor(red: 267/255.0, green: 36/255.0, blue: 0, alpha: 1.0), for: .normal)
        footerView.addSubview(logoutBtn)
        logoutBtn.center = footerView.center
        logoutBtn.addTarget(self, action: #selector(logout(_:)), for: .touchUpInside)
        
        self.mainTableView.tableFooterView = footerView
    }
    
    @objc func logout(_ sender: UIButton) {
        let alertVC = UIAlertController(title: nil, message: "退出后不会删除任何历史数据，下次登录依然可以使用本账号。", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "退出登录", style: .destructive) { _ in
            AppDelegate.currentUser.value = nil
            let user = AppDelegate.getLastUserInfo()
            let passwordLoginVC: SCPasswdLoginViewController = UIStoryboard.storyboard(storyboard: .Login).initViewController()
            passwordLoginVC.userInfo = user
            let navVC = UINavigationController(rootViewController: passwordLoginVC)
            UIApplication.shared.keyWindow?.rootViewController = navVC
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertVC.addAction(logoutAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func tableViewHeaderSetting() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 250.0))
        postrait = UIButton(frame: CGRect(x: 0, y: 0, width: 80.0, height: 80.0))
        postrait.addTarget(self, action: #selector(showProfile(sender:)), for: .touchUpInside)
        let nickName = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30.0))
        nickName.textAlignment = .center
        nickName.textColor = UIColor(red: 112/255.0, green: 112/255.0, blue: 112/255.0, alpha: 1.0)
        nickName.font = UIFont.systemFont(ofSize: 14.0)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: 150.0, height: 1.0))
        lineView.backgroundColor = UIColor(red: 151/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)
        headerView.addSubview(postrait)
        headerView.addSubview(nickName)
        headerView.addSubview(lineView)
        
        postrait.center = CGPoint(x: headerView.center.x, y: headerView.center.y - 20.0)
        nickName.frame.origin.y = postrait.frame.maxY + 10.0
        lineView.center = CGPoint(x: headerView.center.x, y: nickName.frame.maxY + 10.0)
        
        postrait.setImage(UIImage(named: "take_photo"), for: .normal)
        postrait.layer.cornerRadius = postrait.bounds.height / 2.0
        postrait.clipsToBounds = true
        
        nickName.text = "ArcherLj"
        
        self.mainTableView.tableHeaderView = headerView
        
        postraitUpdated()
    }
    
    @objc func showProfile(sender: UIButton) {
        let profileVC: SCProfileViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}

extension SCSettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.className(cs: SCSettingTableViewCell.self), for: indexPath) as? SCSettingTableViewCell else {
            fatalError("Couldn't inital an SCSettingTableViewCell with identifier: \(String.className(cs: SCSettingTableViewCell.self))")
        }
        
        cell.iconImageView.image = cellImages[indexPath.row]
        cell.titleLabel.text = cellTitles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let cardManageVC: SCCardManageViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
            self.navigationController?.pushViewController(cardManageVC, animated: true)
        case 1:
            let payPlanVC: SCPayPlanTableViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
            self.navigationController?.pushViewController(payPlanVC, animated: true)
        case 2:
            let payAndRateVC: SCPayAndRateViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
            self.navigationController?.pushViewController(payAndRateVC, animated: true)
        case 3:
            let warning = SCAlert.showWarning(title: "提示", message: "该功能暂未开放，敬请期待", cancelBtnTitle: "期待")
            self.present(warning, animated: true, completion: nil)
            return
        default:
            break
        }
    }
}
