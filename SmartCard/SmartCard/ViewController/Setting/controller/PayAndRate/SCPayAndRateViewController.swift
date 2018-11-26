//
//  SCPayAndRateViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/26.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCPayAndRateViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var payWay: UITextField!
    @IBOutlet weak var rate: UITextField!
    var payAndRates: [PayWayARate] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支付方式及费率"
        self.view.backgroundColor = UIColor.white
        
        adapteKeyboard = true
        tableViewInit()
        addViewBottomConstraint.constant = -150
        getAllPayARate()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getAllPayARate() {
        payAndRates.removeAll()
        if let rs = PayWayARateManager.getAll() {
            payAndRates.append(contentsOf: rs)
            self.tableView.reloadData()
        }
    }
    
    func tableViewInit() {
        let addBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100.0))
        addBtn.setTitle("添加", for: .normal)
        addBtn.setTitleColor(UIColor(red: 193/255.0, green: 187/255.0, blue: 20/255.0, alpha: 1.0), for: .normal)
        addBtn.addTarget(self, action: #selector(addNewPayAndRate(sender:)), for: .touchUpInside)
        self.tableView.tableFooterView = addBtn
        
        self.tableView.contentInset = UIEdgeInsets(top: 30.0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func addNewPayAndRate(sender: UIButton) {
        self.addViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        self.payWay.resignFirstResponder()
        self.rate.resignFirstResponder()
        
        guard let payAWay = payWay.text, !payAWay.isEmpty else {
            showErrorHud(title: "刷卡方式不合法")
            return
        }
        
        guard let rate = rate.text, !rate.isEmpty, Float(rate)! < 1 else {
            showErrorHud(title: "费率不合法")
            return
        }
        
        if !PayWayARateManager.save(payWay: payAWay, rate: Float(rate)!) {
            showErrorHud(title: "保存失败！请退出重试!")
            return
        }
        
        self.payWay.text = nil
        self.rate.text = nil
        
        showSuccessHud(title: "保存成功")
        getAllPayARate()
        hideAddView()
    }
    
    func hideAddView() {
        self.addViewBottomConstraint.constant = -150
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: .curveLinear, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension SCPayAndRateViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payAndRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SCRemoveableTableViewCell else {
            fatalError("Couldn't initial cell with identifier Cell")
        }
        
        let payAndRate = self.payAndRates[indexPath.row]
        let cellView: SCPayARateCellContent = cell.cellContentView as! SCPayARateCellContent
        cellView.configure(payWayARate: payAndRate)
        
        cell.cellRemoved = {
            if PayWayARateManager.delete(payWay: payAndRate.payWay!) {
                self.payAndRates.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if SCRemoveableTableViewCell.sRemoveShowing {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SCRemoveableTableViewCell.sNotificaionName), object: nil, userInfo: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SCRemoveableTableViewCell.sNotificaionName), object: nil, userInfo: nil)
        hideAddView()
    }
}
