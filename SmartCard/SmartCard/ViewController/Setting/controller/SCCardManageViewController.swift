//
//  SCCardManageViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/20.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift

class SCCardManageViewController: UIViewController {
    
    @IBOutlet weak var cardCount: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    var cardInfos: [CardInfo]?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "信用卡管理"
        
        getAllCard()
    }
    
    func getAllCard() {
        HUD.flash(.progress)
        cardInfos = CardInfoManager.getAll() ?? []
        cardCount.text = "信用卡(\(cardInfos?.count ?? 0))"
        mainTableView.reloadData()
        HUD.hide()
    }
    
    @IBAction func addNewCard(_ sender: UIButton) {
        let addCreditCardVC: SCAddCreditCardViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
        _ = addCreditCardVC.done.subscribe(onNext: { cardInfo in
            self.cardInfos?.append(cardInfo)
            self.cardCount.text = "信用卡(\(self.cardInfos?.count ?? 0))"
            self.mainTableView.reloadData()
            
            let indexPath = IndexPath(row: self.cardInfos!.count - 1, section: 0)
            self.mainTableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        })
        self.navigationController?.pushViewController(addCreditCardVC, animated: true)
    }
    
}

extension SCCardManageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cardInfos = cardInfos {
            return cardInfos.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? SCRemoveableTableViewCell else {
            fatalError("Couldn't inital SCCardmanageTableViewCell with identifier: CellID")
        }
        
        let cardInfo = cardInfos![indexPath.row]
     
        cell.selectionStyle = .none
        let cellContentView = cell.cellContentView as! SCCardManageCellContentView
        cellContentView.configuer(cardInfo: cardInfo)
        cell.cellRemoved = {
            for ci in self.cardInfos! {
                if cardInfo.cardNumber == ci.cardNumber {
                    let rs = CardInfoManager.remove(cardNumber: cardInfo.cardNumber!)
                    if rs {
                        self.cardInfos!.remove(at: self.cardInfos!.firstIndex(of: ci)!)
                    } else {
                        showErrorHud(title: "删除信用卡失败!")
                    }
                    break
                }
            }
            tableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cardInfo = cardInfos![indexPath.row]
        let addCreditCardVC: SCAddCreditCardViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
        addCreditCardVC.cardNumberToEdit = cardInfo.cardNumber
        _ = addCreditCardVC.done.subscribe(onNext: { cardInfo in
            for ci in self.cardInfos! {
                if ci.cardNumber == cardInfo.cardNumber {
                    ci.creditLines = cardInfo.creditLines
                    ci.creditBillDate = cardInfo.creditBillDate
                    ci.gracePeriod = cardInfo.gracePeriod
                    ci.quickPayLines = cardInfo.quickPayLines
                    break
                }
            }
            
            tableView.reloadData()
        })
        self.navigationController?.pushViewController(addCreditCardVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SCRemoveableTableViewCell.sNotificaionName), object: nil, userInfo: nil)
    }
}
