//
//  SCSellerManageViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/26.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCSellerManageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seller: UITextField!
    @IBOutlet weak var minPayNum: UITextField!
    @IBOutlet weak var maxPayNum: UITextField!
    @IBOutlet weak var addNewBottomConstraint: NSLayoutConstraint!
    var sellerConfigures: [SellerConfigure] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商户管理"
        
        adapteKeyboard = true
        self.addNewBottomConstraint.constant = -160
        tableViewSetting()
        getAllData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func tableViewSetting() {
        self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        let addBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80.0))
        addBtn.setTitle("添加", for: .normal)
        addBtn.setTitleColor(UIColor(red: 197/255.0, green: 191/255.0, blue: 32/255.0, alpha: 1.0), for: .normal)
        addBtn.addTarget(self, action: #selector(addBtnAction(sender:)), for: .touchUpInside)
        self.tableView.tableFooterView = addBtn
    }
    
    func getAllData() {
        self.sellerConfigures.removeAll()
        if let rs = SellerConfigureManager.getAll() {
            self.sellerConfigures.append(contentsOf: rs)
            self.tableView.reloadData()
        }
    }
    
    @objc func addBtnAction(sender: UIButton) {
        self.addNewBottomConstraint.constant = 0
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideAddNewView() {
        self.addNewBottomConstraint.constant = -160
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        seller.resignFirstResponder()
        minPayNum.resignFirstResponder()
        maxPayNum.resignFirstResponder()
        
        guard let sellerName = seller.text, !sellerName.isEmpty else {
            showErrorHud(title: "商户名称不合法")
            return
        }
        
        guard let minPay = minPayNum.text, !minPay.isEmpty else {
            showErrorHud(title: "最小消费不合法")
            return
        }
        
        guard let maxPay = maxPayNum.text, !maxPay.isEmpty, Float(maxPay)! > Float(minPay)! else {
            showErrorHud(title: "最大消费不合法")
            return
        }
        
        let rs = SellerConfigureManager.save(sellerName: sellerName, minPay: Int16(minPay)!, maxPay: Int16(maxPay)!)
        if !rs {
            showErrorHud(title: "保存失败")
            return
        }
        
        seller.text = nil
        minPayNum.text = nil
        maxPayNum.text = nil
        
        hideAddNewView()
        getAllData()
    }
}

extension SCSellerManageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sellerConfigures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SCRemoveableTableViewCell else {
            fatalError("Couldn't inital SCRemoveableTableViewCell with identifier Cell.")
        }
        
        let sellerConfigure = self.sellerConfigures[indexPath.row]
        let cellView = cell.cellContentView as! SCSellerCellContent
        cellView.configure(sellerConfigure: sellerConfigure)
        cell.selectionStyle = .none
        cell.cellRemoved = {
            let rs = SellerConfigureManager.delete(sellerName: sellerConfigure.sellerName!)
            if rs {
                self.sellerConfigures.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SCRemoveableTableViewCell.sNotificaionName), object: nil, userInfo: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideAddNewView()
        NotificationCenter.default.post(name: NSNotification.Name(SCRemoveableTableViewCell.sNotificaionName), object: nil, userInfo: nil)
    }
}
