//
//  SCSwipNowViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/12/3.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class SCSwipNowViewController: UIViewController {
    
    @IBOutlet weak var iconScrollView: UIScrollView!
    @IBOutlet weak var bussinessType: UILabel!
    @IBOutlet weak var payNum: UITextField!
    @IBOutlet weak var payType: UIButton!
    @IBOutlet weak var payCharge: UILabel!
    var selectedBankIDs: Set<Int>!
    let bankIconWH: CGFloat = 60.0
    var maskView: UIView!
    var payNumNow = Variable<Int>(0)
    var payRateNow = Variable<(Float, Float)>((0,0))
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "刷卡"
        
        adapteKeyboard = true
        getRoundomBusinessAndPayNum()
        viewInit()
        bankIconSetting()
        rateSetting()
    }
    
    func rateSetting() {
        _ = payNum.rx.text.orEmpty.subscribe(onNext: { str in
            if let num = Int(str) {
                self.payNumNow.value = num
            } else {
                self.payNumNow.value = 0
            }
        })
        
        let rateObservable = Observable.combineLatest(payNumNow.asObservable(), payRateNow.asObservable()) { (payNum, payRate) in
            return (payNum, payRate)
        }
        
        _ = rateObservable.subscribe(onNext: { (arg0) in
            let (num, (rate, charge)) = arg0
            self.payCharge.text = String(format: "%0.2f", Float(num) * rate / 100 + charge)
        }).disposed(by: bag)
    }
    
    func viewInit() {
        
        payNum.maxLength = 4
        
        self.payType.layer.borderColor = UIColor.lightGray.cgColor
        self.payType.layer.borderWidth = 1.0
        self.payType.layer.cornerRadius = 3.0
        self.payType.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        maskView = UIView(frame: view.bounds)
        maskView.backgroundColor = UIColor(white: 0, alpha: 0.4)
    }
    
    func bankIconSetting() {
        
        let wh = iconScrollView.bounds.height > bankIconWH ? bankIconWH : iconScrollView.bounds.height
        var i: CGFloat = 0
        let gap: CGFloat = 15.0
        let y = iconScrollView.bounds.height > bankIconWH ? (iconScrollView.bounds.height - bankIconWH) / 2 : 0
        
        var startX:CGFloat = 0
        if iconScrollView.bounds.width > (wh + gap) * CGFloat(selectedBankIDs.count) {
            startX = (iconScrollView.bounds.width - CGFloat(selectedBankIDs.count) * wh - gap * CGFloat(selectedBankIDs.count - 1)) / 2
        }
        for index in selectedBankIDs {
            let bankIcon = SCBank.Icons[index]
            let iconImgView = UIImageView(frame: CGRect(x: (wh + gap) * i + startX, y: y, width: wh, height: wh))
            iconImgView.contentMode = .scaleAspectFit
            iconImgView.image = bankIcon
            iconScrollView.addSubview(iconImgView)
            i += 1
        }
        
        iconScrollView.contentSize = CGSize(width: CGFloat(selectedBankIDs.count) * (wh + gap), height: wh)
    }
    
    @IBAction
    func swipSuccess(sender: UIButton) {

        HUD.show(.progress)

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = format.string(from: Date())

        let rs = PayRecordManager.save(bankIDs: selectedBankIDs, sellerName: bussinessType.text!, payNum: Float(payNum.text!)!, payWay: payType.titleLabel!.text!, charge: Float(payCharge.text!)!, settleMented: false, settleDate: "", payDate: dateStr)

        HUD.hide()
        if rs {
            NotificationCenter.default.post(name: SCNotificationName.payActionSuccess(), object: nil)
            showSuccessHud(title: "刷卡记录保存成功") {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            showErrorHud(title: "刷卡记录保存失败，请重试")
        }
    }
    
    @IBAction
    func showPayTypes(sender: UIButton) {
        view.addSubview(maskView)
        let selectVC = SCSelectSwipTypeViewController()
        selectVC.willMove(toParent: self)
        self.addChild(selectVC)
        self.view.addSubview(selectVC.view)
        selectVC.didMove(toParent: self)
        
        let selectVCH:CGFloat = 240.0
        let viewH = view.bounds.height
        let viewW = view.bounds.width
        selectVC.view.frame = CGRect(x: 0, y: viewH - selectVCH, width: viewW, height: selectVCH)
        selectVC.view.transform = CGAffineTransform(translationX: 0, y: selectVCH)
        maskView.alpha = 0.0
        
        UIView.animate(withDuration: 0.3, animations: {
            selectVC.view.transform = CGAffineTransform.identity
            self.maskView.alpha = 1.0
        }, completion: nil)
        
        _ = selectVC.selectedObserverble.subscribe(onNext: { payType in
            let title = payType.payWay! + "(费率" + String(payType.rate) + "%)"
            self.payType.setTitle(title, for: .normal)
            self.payRateNow.value = (payType.rate, payType.charge)
        }, onCompleted: {
            UIView.animate(withDuration: 0.3, animations: {
                selectVC.view.transform = CGAffineTransform(translationX: 0, y: selectVCH)
                self.maskView.alpha = 0.0
            }, completion: { _ in
                self.maskView.removeFromSuperview()
                selectVC.view.removeFromSuperview()
                selectVC.willMove(toParent: nil)
                selectVC.removeFromParent()
                selectVC.didMove(toParent: nil)
            })
        })
    }
}

extension SCSwipNowViewController {
    func getRoundomBusinessAndPayNum() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        let hourNow = Int(formatter.string(from: Date()))!
        
        if let payPlans = PayPlanManager.getAll() {
            for payPlan in payPlans {
                if hourNow > Int(payPlan.startHour) && hourNow < Int(payPlan.endHour) {
                    let sellerNames = payPlan.sellerNames!.components(separatedBy: "///")
                    let selectedSellerIndex = Int(arc4random() % UInt32(sellerNames.count))
                    if let sellerInfo = SellerConfigureManager.get(sellerName: sellerNames[selectedSellerIndex]) {
                        let randomMax = UInt32(sellerInfo.maxPay - sellerInfo.minPay)
                        let randomPayNum = Int(arc4random() % randomMax) + Int(sellerInfo.minPay)
                        bussinessType.text = sellerInfo.sellerName
                        payNum.text = String(randomPayNum)
                        payNumNow.value = randomPayNum
                    } else {
                        showErrorHud(title: "获取刷卡计划异常，请退出重试!")
                    }
                    break
                }
            }
        } else {
            showErrorHud(title: "请先去设置里添加刷卡计划")
        }
    }
}
