//
//  SCAddCreditCardViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/20.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCAddCreditCardViewController: UIViewController {
    
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var bankIcon: UIImageView!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var creditLines: UITextField!
    @IBOutlet weak var creditBillDate: UIButton!
    @IBOutlet weak var creditRepaymentDate: UIButton!
    @IBOutlet weak var creditRepayDelayDayNumber: UITextField!
    @IBOutlet weak var quickPayLines: UITextField!
    @IBOutlet weak var radiuBtnT: UIButton!
    @IBOutlet weak var radiuBtnB: UIButton!
    
    @IBOutlet weak var guideContainerView: UIView!
    @IBOutlet weak var guideImageView: UIImageView!

    
    ////////////////////////////////////////////////////////////////////////////////////////
    //              LifeCycle methods
    ////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加信用卡"
        
        preSetting()
    }
    
    deinit {
        if adapteKeyboard {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////
    //              other methods
    ////////////////////////////////////////////////////////////////////////////////////////
    func preSetting() {
        detailContainerView.isHidden = true
        guideAnimation()
        
        creditBillDate.layer.borderWidth = 1.0
        creditBillDate.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0).cgColor
        
        creditRepaymentDate.layer.borderWidth = 1.0
        creditRepaymentDate.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0).cgColor
        
        radiuBtnChangeToDate(useDate: true)
    }
    
    func radiuBtnChangeToDate(useDate: Bool) {
        creditRepaymentDate.isEnabled = useDate
        creditRepayDelayDayNumber.isEnabled = !useDate
        
        let imageNormal = UIImage(named: "radio_normal")
        let imageSelected = UIImage(named: "radio_selected")
        radiuBtnT.setImage(useDate ? imageSelected : imageNormal, for: .normal)
        radiuBtnB.setImage(useDate ? imageNormal : imageSelected, for: .normal)
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
    }
    
    @IBAction func selectCreditRepaymentDate(_ sender: UIButton) {
    }
    
    @IBAction func radiuBtnTAction(_ sender: UIButton) {
        radiuBtnChangeToDate(useDate: true)
    }
    
    @IBAction func radiuBtnBAction(_ sender: UIButton) {
        radiuBtnChangeToDate(useDate: false)
    }
    
    @IBAction func save(_ sender: UIButton) {
    }
    
    @IBAction func chooseBank(_ sender: UIButton) {
        let selectBankVC: SCSelectBankViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
        _ = selectBankVC.selected.subscribe(onNext: { [weak self] in
            self?.selectBankWithIndex(index: $0)
        })
        self.navigationController?.pushViewController(selectBankVC, animated: true)
    }
}
