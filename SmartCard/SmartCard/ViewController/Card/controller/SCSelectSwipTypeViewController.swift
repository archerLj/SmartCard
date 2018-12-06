//
//  SCSelectSwipTypeViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/12/4.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit
import RxSwift

class SCSelectSwipTypeViewController: UIViewController {
    
    fileprivate let selectedSubject = PublishSubject<PayWayARate>()
    var selectedObserverble: Observable<PayWayARate> {
        return selectedSubject.asObservable()
    }

    var tableView: UITableView!
    var titleLabel: UILabel!
    var payTypes: [PayWayARate]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewInit()
        getDatas()
    }
    
    func getDatas() {
        payTypes = PayWayARateManager.getAll()
        tableView.reloadData()
    }
    
    func viewInit() {
        
        view.backgroundColor = UIColor.white
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40.0))
        titleLabel.textColor = UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 12.0)
        titleLabel.text = "支付方式选择"
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        tableView = UITableView(frame: CGRect(x: 0, y: titleLabel.frame.maxY, width: view.bounds.width, height: view.bounds.height - titleLabel.frame.maxY), style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let cancelBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50.0))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.red, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancel(sender:)), for: .touchUpInside)
        tableView.tableFooterView = cancelBtn
    }
    
    @objc func cancel(sender: UIButton) {
        selectedSubject.onCompleted()
    }
}

extension SCSelectSwipTypeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let types = payTypes {
            return types.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        let payType = payTypes![indexPath.row]
        cell.textLabel?.text = payType.payWay! + "：" + String(payType.rate) + "%"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let payType = payTypes![indexPath.row]
        selectedSubject.onNext(payType)
        selectedSubject.onCompleted()
    }
}
