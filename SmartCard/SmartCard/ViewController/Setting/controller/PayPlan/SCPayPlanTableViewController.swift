//
//  SCPayPlanTableViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/26.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCPayPlanTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "刷卡计划"

        navSetting()
        tableViewSetting()
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
        let newPlanVC: SCNewPlanViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
        self.navigationController?.pushViewController(newPlanVC, animated: true)
        _ = newPlanVC.addResult.subscribe(onNext: { newPlan in
            print(newPlan.startHour)
            print(newPlan.endHour)
            print(newPlan.sellerNames)
        })
    }
    
    func navSetting() {
        let rightNavBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44.0))
        rightNavBtn.setTitle("商户管理", for: .normal)
        rightNavBtn.setTitleColor(UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0), for: .normal)
        rightNavBtn.addTarget(self, action: #selector(rightNavBtnAction(sender:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavBtn)
    }
    
    @objc func rightNavBtnAction(sender: UIButton) {
        let sellerVC: SCSellerManageViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
        self.navigationController?.pushViewController(sellerVC, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
