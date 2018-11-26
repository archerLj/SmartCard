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
    }
    
    func tableViewFooterSetting() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150.0))
        let logoutBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100.0, height: 50.0))
        
        logoutBtn.setTitle("退出登录", for: .normal)
        logoutBtn.setTitleColor(UIColor(red: 267/255.0, green: 36/255.0, blue: 0, alpha: 1.0), for: .normal)
        footerView.addSubview(logoutBtn)
        logoutBtn.center = footerView.center
        
        self.mainTableView.tableFooterView = footerView
    }
    
    func tableViewHeaderSetting() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 250.0))
        let postrait = UIImageView(frame: CGRect(x: 0, y: 0, width: 80.0, height: 80.0))
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
        
        postrait.image = UIImage(named: "take_photo")
        postrait.layer.cornerRadius = postrait.bounds.height / 2.0
        postrait.clipsToBounds = true
        
        nickName.text = "ArcherLj"
        
        self.mainTableView.tableHeaderView = headerView
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
        default:
            break
        }
    }
}
