//
//  SCAddCreditCardViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/20.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift

class SCAddCreditCardViewController: UIViewController {
    
    fileprivate let doneSubject = PublishSubject<CardInfo>()
    var done: Observable<CardInfo> {
        return doneSubject.asObservable()
    }
    
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var bankIcon: UIImageView!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var creditLines: SCTextField!
    @IBOutlet weak var creditBillDate: UIButton!
    @IBOutlet weak var gracePeriod: SCTextField!
    @IBOutlet weak var quickPayLines: SCTextField!
    @IBOutlet weak var cardNumber: SCTextField!
    
    @IBOutlet weak var guideContainerView: UIView!
    @IBOutlet weak var guideImageView: UIImageView!
    
    @IBOutlet weak var saveBtn: UIButton!
    var editBtn: UIButton!
    
    let imageNormal = UIImage(named: "radio_normal")
    let imageSelected = UIImage(named: "radio_selected")
    var maskView : UIView!
    var bankID: Int?
    var cardNumberToEdit: String?

    
    ////////////////////////////////////////////////////////////////////////////////////////
    //              LifeCycle methods
    ////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加信用卡"

        preSetting()
        if let cardNumberToEdit = cardNumberToEdit {
            showCardMessage(cardNumber: cardNumberToEdit)
        } else {
            detailContainerView.isHidden = true
            guideAnimation()
        }
    }
    
    deinit {
        doneSubject.onCompleted()
        if adapteKeyboard {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////
    //              只展示并编辑信用卡信息
    ////////////////////////////////////////////////////////////////////////////////////////
    @objc func editCardInfo() {
        
        if editBtn.isSelected {
            // 保存
            guard let (cardNumber, creditBillDate, creditLines, quikPayLines, gracePeriod) = checkInput() else {
                return
            }
            let rs = CardInfoManager.update(cardNumber: cardNumber,
                                   creditBillDate: Int16(creditBillDate)!,
                                   creditLines: Int32(creditLines)!,
                                   quickPayLines: Int16(quikPayLines)!,
                                   gracePeriod: Int16(gracePeriod)!)
            if let rs = rs {
                showSuccessHud(title: "保存成功")
                doneSubject.onNext(rs)
                doneSubject.onCompleted()
                delay(3.0) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                showErrorHud(title: "保存失败!")
            }
            
        } else {
            print("edit....")
            self.creditLines.isEnabled = true
            self.creditBillDate.isEnabled = true
            self.gracePeriod.isEnabled = true
            self.quickPayLines.isEnabled = true
            
            self.creditLines.textColor = UIColor.black
            self.gracePeriod.textColor = UIColor.black
            self.quickPayLines.textColor = UIColor.black
            self.creditBillDate.setTitleColor(UIColor.black, for: .normal)
            
            UIView.transition(with: editBtn, duration: 0.5, options: .curveEaseOut, animations: {
                self.editBtn.setTitle("保存", for: .normal)
            }, completion: nil)
        }
        
        editBtn.isSelected = true
    }
    
    func showCardMessage(cardNumber: String) {
        let cardInfo = CardInfoManager.get(cardNumber: cardNumber)
        if let cardInfo = cardInfo {
            let index = Int(cardInfo.bankID)
            self.bankIcon.image = SCBank.Icons[index]
            self.bankName.text = SCBank.Names[index]
            self.creditLines.text = String(cardInfo.creditLines)
            self.creditBillDate.setTitle(String(cardInfo.creditBillDate), for: .normal)
            self.gracePeriod.text = String(cardInfo.gracePeriod)
            self.quickPayLines.text = String(cardInfo.quickPayLines)
            self.cardNumber.text = cardInfo.cardNumber
            
            self.creditLines.textColor = UIColor.lightGray
            self.gracePeriod.textColor = UIColor.lightGray
            self.quickPayLines.textColor = UIColor.lightGray
            self.creditBillDate.setTitleColor(UIColor.lightGray, for: .normal)
            
            self.creditLines.isEnabled = false
            self.creditBillDate.isEnabled = false
            self.gracePeriod.isEnabled = false
            self.quickPayLines.isEnabled = false
            
            self.cardNumber.textColor = UIColor.lightGray
            self.cardNumber.isEnabled = false
            self.cardNumber.layer.borderWidth = 2.0
            self.cardNumber.layer.borderColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0).cgColor
            self.saveBtn.isHidden = true
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editBtn)
        } else {
            showErrorHud(title: "获取信用卡信息失败！请删除信用卡后重新添加")
            delay(3.0) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////
    //              other methods
    ////////////////////////////////////////////////////////////////////////////////////////
    func preSetting() {
        
        adapteKeyboard = true
        
        creditBillDate.layer.borderWidth = 1.0
        creditBillDate.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0).cgColor
        
        maskView = UIView(frame: UIScreen.main.bounds)
        editBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50.0, height: 44.0))
        editBtn.addTarget(self, action: #selector(editCardInfo), for: .touchUpInside)
        editBtn.setTitle("编辑", for: .normal)
        editBtn.setTitleColor(UIColor(red: 110/255.0, green: 110/255.0, blue: 110/255.0, alpha: 1.0), for: .normal)
    }
    
    func guideAnimation() {
        let animate = CABasicAnimation(keyPath: "position.y")
        animate.fromValue = guideImageView.frame.maxY
        animate.toValue = guideImageView.frame.maxY + 35.0
        animate.duration = 1.0
        animate.beginTime = CACurrentMediaTime()
        animate.isRemovedOnCompletion = false
        animate.repeatCount = .infinity
        guideImageView.layer.add(animate, forKey: nil)
    }
    
    func selectBankWithIndex(index: Int) {
        
        bankID = index
        
        bankIcon.image = SCBank.Icons[index]
        bankName.text = SCBank.Names[index]
        
        detailContainerView.isHidden = false
        guideContainerView.isHidden = true
        guideImageView.layer.removeAllAnimations()
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////
    //              Button actions
    ////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func selectCreditBillDate(_ sender: UIButton) {
        
        creditLines.resignFirstResponder()
        gracePeriod.resignFirstResponder()
        quickPayLines.resignFirstResponder()
        cardNumber.resignFirstResponder()
        selectDayWithMaxDay(maxDay: 28)
    }
    
    func checkInput() -> (String, String, String, String, String)? {
        guard let cardNumber = self.cardNumber.text, !cardNumber.isEmpty, cardNumber.count == 16 else {
            showErrorHud(title: "信用卡卡号不合法")
            return nil
        }
        guard let creditBillDate = self.creditBillDate.titleLabel?.text else {
            showErrorHud(title: "账单日为空")
            return nil
        }
        guard let creditLines = self.creditLines.text else {
            showErrorHud(title: "信用额度为空")
            return nil
        }
        guard let quikPayLines = self.quickPayLines.text else {
            showErrorHud(title: "云闪付限额为空")
            return nil
        }
        guard let gracePeriod = self.gracePeriod.text, Int(gracePeriod)! < 60 else {
            showErrorHud(title: "免息期不合法")
            return nil
        }
        
        return (cardNumber, creditBillDate, creditLines, quikPayLines, gracePeriod)
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        guard let (cardNumber, creditBillDate, creditLines, quikPayLines, gracePeriod) = checkInput() else {
            return
        }
        
        if let _ = CardInfoManager.get(cardNumber: cardNumber) {
            showErrorHud(title: "卡号已存在")
            return
        }
        
        let rs = CardInfoManager.save(bankID: Int16(bankID!),
                             cardNumber: cardNumber,
                             creditBillDate: Int16(creditBillDate)!,
                             creditLines: Int32(creditLines)!,
                             quickPayLines: Int16(quikPayLines)!,
                             gracePeriod: Int16(gracePeriod)!)
        if let rs = rs {
            showSuccessHud(title: "保存成功")
            doneSubject.onNext(rs)
            doneSubject.onCompleted()
            delay(3.0) {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            showErrorHud(title: "存储失败，请退出重试！")
        }
    }
    
    @IBAction func chooseBank(_ sender: UIButton) {
        let selectBankVC: SCSelectBankViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
        _ = selectBankVC.selected.subscribe(onNext: { [weak self] in
            self?.selectBankWithIndex(index: $0)
        })
        self.navigationController?.pushViewController(selectBankVC, animated: true)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////
    //              选择日期
    ////////////////////////////////////////////////////////////////////////////////////////
    func selectDayWithMaxDay(maxDay: Int) {
        
        self.view.addSubview(maskView)
        
        let selectDayVC = SCDayTableViewController()
        selectDayVC.maxDay = maxDay
        selectDayVC.willMove(toParent: self)
        self.addChild(selectDayVC)
        self.view.addSubview(selectDayVC.view)
        selectDayVC.view.frame = CGRect(x: 0, y: view.bounds.height - 300.0, width: view.bounds.width, height: 300.0)
        selectDayVC.didMove(toParent: self)
        
        selectDayVC.view.transform = CGAffineTransform(translationX: 0, y: 300.0)
        maskView.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.maskView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            selectDayVC.view.transform = CGAffineTransform.identity
        }, completion: nil)
        
        _ = selectDayVC.selectDay.subscribe(onNext: {
            self.creditBillDate.setTitle(String($0), for: .normal)
        }, onCompleted: {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.maskView.backgroundColor = UIColor.clear
                selectDayVC.view.transform = CGAffineTransform(translationX: 0, y: 300.0)
            }, completion: { _ in
                self.maskView.removeFromSuperview()
                selectDayVC.willMove(toParent: nil)
                selectDayVC.view.removeFromSuperview()
                selectDayVC.removeFromParent()
                selectDayVC.didMove(toParent: nil)
            })
        })
    }
}
