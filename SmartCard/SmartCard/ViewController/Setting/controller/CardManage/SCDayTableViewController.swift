//
//  SCDayTableViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/22.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SCDayTableViewController: UIViewController {
    
    fileprivate var selectDaySubject = PublishSubject<Int>()
    var selectDay: Observable<Int> {
        return selectDaySubject.asObservable()
    }
    
    var titleInfo: String?
    var tableView: UITableView!
    var titleInfoLabel: UILabel!
    var cancelBtn: UIButton!
    var maxDay = 28

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        titleInfoLabel = UILabel(frame: CGRect.zero)
        
        if let title = titleInfo {
            titleInfoLabel.text = title
        } else {
            titleInfoLabel.text = "请选择日期"
        }
        titleInfoLabel.textColor = UIColor.lightGray
        titleInfoLabel.font = UIFont.systemFont(ofSize: 12.0)
        titleInfoLabel.textAlignment = .center
        
        cancelBtn = UIButton(frame: CGRect.zero)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.red, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelAction(sender:)), for: .touchUpInside)
        
        self.tableView = UITableView(frame: CGRect.zero, style: .plain)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubview(titleInfoLabel)
        self.view.addSubview(tableView)
        self.view.addSubview(cancelBtn)
    }
    
    @objc func cancelAction(sender: UIButton) {
        selectDaySubject.onCompleted()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleInfoLabel.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50.0)
        cancelBtn.frame = CGRect(x: 0, y: view.bounds.height - 80.0, width: view.bounds.width, height: 80.0)
        tableView.frame = CGRect(x: 0, y: 50.0, width: view.bounds.width, height: view.bounds.height - 130.0)
    }
}

extension SCDayTableViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxDay
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1)
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectDaySubject.onNext(indexPath.row + 1)
        selectDaySubject.onCompleted()
    }
}
