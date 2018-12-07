//
//  SCHistoryViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/19.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCHistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var footerView: UIView!
    var payRecords = [[PayRecord]]()
    var topViewLable: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "历史记录"
        
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        getTodayData()
        tableViewSetting()
        NotificationCenter.default.addObserver(self, selector: #selector(getTodayData), name: SCNotificationName.payActionSuccess(), object: nil)
    }
    
    func tableViewSetting() {
        topViewLable = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80.0))
        topViewLable.textAlignment = .center
        topViewLable.textColor = UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)
        topViewLable.text = "今日刷卡记录"
        tableView.tableHeaderView = topViewLable
    }
    
    @objc func getTodayData() {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd"
        getData(date: dateFormate.string(from: Date()))
    }
    
    func getData(date: String) {
        if let rs = PayRecordManager.getPayRecords(date: date) {
            payRecords = rs
            SCEmptyGuideView.dismiss(from: footerView)
            tableView.tableFooterView = nil
        } else {
            tableView.tableFooterView = footerView
            SCEmptyGuideView.newOne().show(in: footerView, infoImage: UIImage(named: "noData")!, infoTitle: "没有找到刷卡记录", subInfoTitle: "快去刷卡吧")
        }
        tableView.reloadData()
    }
}

extension SCHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return payRecords.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payRecords[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? SCHistoryTableViewCell else {
            fatalError("Couldn't initial SCHistoryTableViewCell with identifier CellID")
        }
        
        let payRecord = payRecords[indexPath.section][indexPath.row]
        cell.configure(payRecord: payRecord)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50.0))
        view.backgroundColor = UIColor.init(white: 0.98, alpha: 1.0)
        
        let payRecord = payRecords[section][0]
        let index = Int(payRecord.bankID)
        
        let icon = UIImageView(frame: CGRect(x: 15, y: 10, width: 30, height: 30))
        icon.contentMode = .scaleAspectFit
        icon.image = SCBank.Icons[index]
        
        let bankName = UILabel(frame: CGRect(x: icon.frame.maxX + 20, y: 0, width: 150.0, height: view.bounds.height))
        bankName.textColor = UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)
        bankName.text = SCBank.Names[index]
        
        let payNumsLabel = UILabel(frame: CGRect(x: bankName.frame.maxX, y: 0, width: view.bounds.width - bankName.frame.maxX, height: view.bounds.height))
        payNumsLabel.font = UIFont.systemFont(ofSize: 14.0)
        payNumsLabel.textAlignment = .left
        payNumsLabel.textColor = UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)
        let payNums = payRecords[section].map { $0.payNum }.reduce(0, +)
        payNumsLabel.text = "已刷\(payNums)元"
        
        view.addSubview(icon)
        view.addSubview(bankName)
        view.addSubview(payNumsLabel)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}
