//
//  SCSelectBankViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/21.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit
import RxSwift

class SCSelectBankViewController: UITableViewController {
    
    fileprivate let selectSubject = PublishSubject<Int>()
    var selected: Observable<Int> {
        return selectSubject.asObservable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择银行"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectSubject.onCompleted()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SCBank.Names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.className(cs: SCSelectBankTableViewCell.self), for: indexPath) as? SCSelectBankTableViewCell else {
            fatalError("Couldn't inital SCSelectBankTableViewCell with identifier: \(SCSelectBankTableViewCell.self)")
        }
        
        cell.icon.image = SCBank.Icons[indexPath.row]
        cell.name.text = SCBank.Names[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectSubject.onNext(indexPath.row)
        selectSubject.onCompleted()
        self.navigationController?.popViewController(animated: true)
    }
}
