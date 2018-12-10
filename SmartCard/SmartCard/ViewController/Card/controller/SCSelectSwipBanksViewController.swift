//
//  SCSelectSwipBanksViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/12/3.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCSelectSwipBanksViewController: UITableViewController {

    var checkedArr = [Bool]()
    var selected = Set<String>()
    var myBanks = [CardInfo]()
    var payNumsToday = [Float?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择银行卡"
        
        navSetting()
        getData()
        NotificationCenter.default.addObserver(self, selector: #selector(getPayNums(notification:)), name: SCNotificationName.payActionSuccess(), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getData() {
        if let cis = CardInfoManager.getAll() {
            myBanks = cis
            checkedArr = [Bool](repeating: false, count: cis.count)
        }
        
        getPayNums()
    }
    
    @objc func getPayNums(notification: Notification? = nil) {
        let cardNums = myBanks.map { $0.cardNumber! }
        payNumsToday = PayRecordManager.getPayNumsOfToday(cardNums: cardNums)
        tableView.reloadData()
    }
    
    func navSetting() {
        let rightBarItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(finishSelect(sender:)))
        rightBarItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    @objc func finishSelect(sender: UIBarButtonItem) {
        
        if selected.count == 0 {
            showErrorHud(title: "请选择银行卡")
            return
        }
        
        let swipNowVC: SCSwipNowViewController = UIStoryboard.storyboard(storyboard: .Card).initViewController()
        swipNowVC.selectedCardNums = selected
        self.navigationController?.pushViewController(swipNowVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBanks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? SCSelectSwipBankTableViewCell else {
            fatalError("Couldn't inital SCSelectSwipBankTableViewCell with identifier CellID")
        }
        
        let cardInfo = myBanks[indexPath.row]
        let payNum = payNumsToday[indexPath.row]
        cell.configure(bankIndex: cardInfo.bankID, checked: checkedArr[indexPath.row], payNumsOfToday: payNum, cardNum: cardInfo.cardNumber!)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cardInfo = myBanks[indexPath.row]
        checkedArr[indexPath.row] = !checkedArr[indexPath.row]
        if checkedArr[indexPath.row] {
            selected.insert(cardInfo.cardNumber!)
        } else {
            selected.remove(cardInfo.cardNumber!)
        }
        tableView.reloadData()
    }
}
