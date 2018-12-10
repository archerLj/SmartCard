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
        let view = Bundle.main.loadNibNamed("SCHistorySectionView", owner: nil, options: nil)?.last as! SCHistorySectionView
        let payRecord = payRecords[section][0]
        if let index = CardInfoManager.getBankID(cardNum: payRecord.cardNum!) {
            view.bankIcon.image = SCBank.Icons[index]
            view.bankName.text = SCBank.Names[index]
            view.cardNum.text = "(\(payRecord.cardNum!.dropFirst(payRecord.cardNum!.count - 4)))"
            let payNums = payRecords[section].map { $0.payNum }.reduce(0, +)
            view.payNums.text = "已刷\(payNums)元"
        } else {
            fatalError("获取银行信息失败，请重试")
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}
