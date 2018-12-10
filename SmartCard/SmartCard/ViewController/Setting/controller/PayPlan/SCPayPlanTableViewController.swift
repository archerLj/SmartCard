//
//  SCPayPlanTableViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/26.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit
import RxSwift

class SCPayPlanTableViewController: UITableViewController {
    
    var payPlans: [PayPlan] = []
    var sellerConfigures: [[SellerConfigure]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "刷卡计划"

        navSetting()
        tableViewSetting()
        getAllPayPlans()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getAllPayPlans() {
        if let rs = PayPlanManager.getAll() {
            payPlans.append(contentsOf: rs)
        }
        
        for payPlan in payPlans {
            sellerConfigures.append(getSellerConfigures(payPlan: payPlan))
        }
        
        self.tableView.reloadData()
    }
    
    func tableViewSetting() {
        self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        
        let addNewPlanBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80.0))
        addNewPlanBtn.setTitle("添加新计划", for: .normal)
        addNewPlanBtn.setTitleColor(UIColor(red: 193/255.0, green: 187/255.0, blue: 20/255.0, alpha: 1.0), for: .normal)
        addNewPlanBtn.addTarget(self, action: #selector(addNewPlan(sender:)), for: .touchUpInside)
        
        self.tableView.tableFooterView = addNewPlanBtn
    }
    
    @objc func addNewPlan(sender: UIButton) {
        
        guard let _ = SellerConfigureManager.getAll() else {
            let warning = SCAlert.showWarning(title: "提示", message: "请先点击右上角 商户管理 添加商户", cancelBtnTitle: "知道了")
            self.present(warning, animated: true, completion: nil)
            return
        }
        
        let newPlanVC: SCNewPlanViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
        self.navigationController?.pushViewController(newPlanVC, animated: true)
        _ = newPlanVC.addResult.subscribe(onNext: { newPlan in
            self.payPlans.append(newPlan)
            self.payPlans = self.payPlans.sorted(by: { (l, r) -> Bool in
                if l.startHour < r.startHour {
                    return true
                }
                
                if l.startHour == r.startHour && l.endHour < r.endHour {
                    return true
                }
                
                return false
            })
            self.sellerConfigures.append(self.getSellerConfigures(payPlan: newPlan))
            self.tableView.reloadData()
        })
    }
    
    func getSellerConfigures(payPlan: PayPlan) -> [SellerConfigure] {
        let sellerNames = payPlan.sellerNames?.components(separatedBy: "///")
        var temps: [SellerConfigure] = []
        for sellerName in sellerNames! {
            if let sellerConfigure = SellerConfigureManager.get(sellerName: sellerName) {
                temps.append(sellerConfigure)
            }
        }
        return temps
    }
    
    func navSetting() {
        let rightNavBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44.0))
        rightNavBtn.setTitle("商户管理", for: .normal)
        rightNavBtn.setTitleColor(UIColor.white, for: .normal)
        rightNavBtn.addTarget(self, action: #selector(rightNavBtnAction(sender:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavBtn)
    }
    
    @objc func rightNavBtnAction(sender: UIButton) {
        let sellerVC: SCSellerManageViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
        self.navigationController?.pushViewController(sellerVC, animated: true)
    }
}

extension SCPayPlanTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payPlans.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SCPayPlanTableViewCell else {
            fatalError("Couldn't initial SCPayPlanTableViewCell with identifier Cell.")
        }
        
        let payPlan = payPlans[indexPath.row]
        let sellerConfigure = sellerConfigures[indexPath.row]
        cell.configure(payPlan: payPlan, sellerConfigures: sellerConfigure)
        
        if payPlans.count == 1 {
            cell.firstCellConfigure()
            cell.lastCellConfigure()
        } else if indexPath.row == 0 {
            cell.firstCellConfigure()
        } else if indexPath.row == payPlans.count - 1 {
            cell.lastCellConfigure()
        }
        
        cell.selectionStyle = .none
        
        cell.deleteCell = {
            self.payPlans.remove(at: indexPath.row)
            self.sellerConfigures.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        cell.edit = {
            let newPlanVC: SCNewPlanViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
            newPlanVC.payPlan = payPlan
            self.navigationController?.pushViewController(newPlanVC, animated: true)
            _ = newPlanVC.addResult.subscribe(onNext: { newPlan in
                self.payPlans[indexPath.row] = newPlan
                self.sellerConfigures[indexPath.row] = self.getSellerConfigures(payPlan: newPlan)
                self.tableView.reloadData()
            })
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let payPlan = self.payPlans[indexPath.row]
        let sellers = payPlan.sellerNames!.components(separatedBy: "///")
        let count = sellers.count
        
        return CGFloat(100 + count * 30)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SCPayPlanTableViewCell.sNotificationName), object: nil, userInfo: nil)
    }
}
