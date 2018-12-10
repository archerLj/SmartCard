//
//  SCCreditCardViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/19.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCCreditCardViewController: UITableViewController {
    
    let topViewH:CGFloat = 100.0
    var topView: SCCreditCardTopView = {
        return Bundle.main.loadNibNamed("SCCreditCardTopView", owner: nil, options: nil)?.last as! SCCreditCardTopView
    }()
    var progress: CGFloat = 0.0
    var topViewIsShowing = false
    let transition = SCCreditNavAnimator()
    var currentCellRect: CGRect!
    var cardInfos: [[CardInfo]] = []
    var cardPayACharges: [[(Float, Float, Float, Float)]] = [] // (lastPays, lastCharges, unSettledPays, unSettledCharges)
    var lastSettleInfo: (Float, Float)! // 上期刷卡量和手续费
    var thisSettleInfo: (Float, Float)! // 本期刷卡量和手续费
    var footerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "信用卡"
        
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        tableViewSetting()
        navSetting()
        getInitDatas()
        NotificationCenter.default.addObserver(self, selector: #selector(creditCardModified(notification:)), name: SCNotificationName.creditCardModified(), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(payActionNotification(notification:)), name: SCNotificationName.payActionSuccess(), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func creditCardModified(notification: Notification) {
        reFetchAllDatas()
    }
    
    @objc func payActionNotification(notification: Notification) {
        reFetchAllDatas()
    }
    
    func reFetchAllDatas() {
        cardInfos.removeAll()
        cardPayACharges.removeAll()
        getInitDatas()
    }
    
    func navSetting() {
        let leftNavItem = UIBarButtonItem(title: "结算", style: .plain, target: self, action: #selector(settlement))
        let rightNavItem = UIBarButtonItem(title: "刷卡", style: .plain, target: self, action: #selector(swipCard))
        leftNavItem.tintColor = UIColor.white
        rightNavItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftNavItem
        self.navigationItem.rightBarButtonItem = rightNavItem
    }
    
    func getInitDatas() {

        guard let cis = CardInfoManager.getAllGroupedByCreditBillDate(), cis.count > 0 else {
            tableView.reloadData()
            tableView.tableFooterView = footerView
            SCEmptyGuideView.newOne().show(in: footerView, infoImage: UIImage(named: "noData")!, infoTitle: "您还没有添加信用卡，到设置-信用卡管理里添加几张信用卡体验下吧", subInfoTitle: "多多益善")
            return
        }
        
        SCEmptyGuideView.dismiss(from: footerView)
        tableView.tableFooterView = nil
        
        cardInfos = cis
        for ci in cardInfos {
            var ciInfos = [(Float, Float, Float, Float)]()
            for c in ci {
                let lastSettle = PayRecordManager.getLastSettlePayNumACharges(cardNum: c.cardNumber!)
                let unSettled = PayRecordManager.getUnsettlePayNumACharges(cardNum: c.cardNumber!)
                ciInfos.append((lastSettle.payNums, lastSettle.charges, unSettled.payNums, unSettled.charges))
            }
            cardPayACharges.append(ciInfos)
        }
        
        lastSettleInfo = PayRecordManager.getLastSettlePayNumACharges()
        thisSettleInfo = PayRecordManager.getUnSettlePayNumACharges()
        self.topView.configure(lastSettlePayNum: lastSettleInfo.0,
                          lastSettleCharge: lastSettleInfo.1,
                          thisSettlePayNum: thisSettleInfo.0,
                          thisSettleCharge: thisSettleInfo.1)
        
        tableView.reloadData()
    }
    
    /// 结算
    @objc func settlement() {
        
        if cardInfos.count == 0 {
            let warning = SCAlert.showWarning(title: "提示", message: "请先到设置-信用卡管理里添加信用卡", cancelBtnTitle: "知道了")
            self.present(warning, animated: true, completion: nil)
            return
        }
        
        let alertVC = UIAlertController(title: "温馨提示", message: "结算和账单日功能一致，结算后的刷卡记录将计入下一个计算周期，再次确认是否要继续结算?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .destructive) { _ in
            let rs = PayRecordManager.settle()
            if rs {
                showSuccessHud(title: "本期结算完成")
                NotificationCenter.default.post(name: SCNotificationName.settleSuccess(), object: nil)
                self.reFetchAllDatas()
            } else {
                showErrorHud(title: "结算失败，请退出重试")
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /// 刷卡
    @objc func swipCard() {
        
        if cardInfos.count == 0 {
            let warning = SCAlert.showWarning(title: "提示", message: "请先到设置-信用卡管理里添加信用卡", cancelBtnTitle: "知道了")
            self.present(warning, animated: true, completion: nil)
            return
        }
        
        if let mainVC = self.navigationController?.parent as? SCMainTabBarViewController {
            navigationController?.delegate = mainVC
            let selectSwipBanks: SCSelectSwipBanksViewController = UIStoryboard.storyboard(storyboard: .Card).initViewController()
            self.navigationController?.pushViewController(selectSwipBanks, animated: true)
        } else {
            fatalError("couldn't get SCMainTabBarViewController from this navigationController in SCCreditCardViewController")
        }
    }
    
    func tableViewSetting() {
        self.topView.frame = CGRect(x: 0, y: -100, width: view.bounds.width, height: 100.0)
        view.addSubview(self.topView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension SCCreditCardViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cardInfos.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardInfos[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SCCreditCardTableViewCell else {
            fatalError("Couldn't initial SCCreditCardTableViewCell with identifier Cell")
        }
        
        let card = cardInfos[indexPath.section][indexPath.row]
        let cpcs = cardPayACharges[indexPath.section][indexPath.row]
        cell.configure(cardInfo: card, cardPayACharges: cpcs)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60.0))
        view.backgroundColor = UIColor.white
        
        let gapView = UIView(frame: CGRect(x: 15, y: 15.0, width: 5.0, height: 30.0))
        gapView.backgroundColor = UIColor(red: 193/255, green: 187/255, blue: 20/255, alpha: 1.0)
        
        let creditBillDate = UILabel(frame: CGRect(x: gapView.frame.maxX + 15, y: 0, width: view.bounds.width - gapView.frame.maxX - 15, height: view.bounds.height))
        creditBillDate.font = UIFont.systemFont(ofSize: 14.0)
        creditBillDate.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        let cardInfo = cardInfos[section][0]
        creditBillDate.text = "账单日: \(cardInfo.creditBillDate)号"
        
        view.addSubview(gapView)
        view.addSubview(creditBillDate)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cardInfo = cardInfos[indexPath.section][indexPath.row]
        let cardPayInfos = cardPayACharges[indexPath.section][indexPath.row]
        
        navigationController?.delegate = self
        let detailVC: SCCardDetailViewController = UIStoryboard.storyboard(storyboard: .Card).initViewController()
        detailVC.cardInfo = cardInfo
        detailVC.cardPayInfos = cardPayInfos
        
        currentCellRect = tableView.convert(tableView.rectForRow(at: indexPath), to: tableView.superview)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = max(-(scrollView.contentOffset.y + scrollView.contentInset.top), 0.0)
        progress = min(max((offsetY - 64) / topView.frame.size.height, 0.0), 1.0)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if progress >= 1.0 && !topViewIsShowing {
            
            UIView.animate(withDuration: 0.3, animations: {
                var newInset = scrollView.contentInset
                newInset.top += self.topViewH
                scrollView.contentInset = newInset
                self.topViewIsShowing = true
            }) { _ in
                delay(5.0, execute: {
                    UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 15, options: .curveEaseIn, animations: {
                        var newInset = scrollView.contentInset
                        newInset.top -= self.topViewH
                        scrollView.contentInset = newInset
                    }, completion: { _ in
                        self.topViewIsShowing = false
                    })
                })
            }
        }
    }
}

extension SCCreditCardViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.originFrame = CGRect(x: currentCellRect.origin.x + 15, y: currentCellRect.origin.y + 15, width: 10, height: 10)
        transition.operation = operation
        return transition
    }
}
