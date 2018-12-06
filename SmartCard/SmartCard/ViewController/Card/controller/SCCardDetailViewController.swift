//
//  SCCardDetailViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/30.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCCardDetailViewController: UIViewController {
    
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var iconBgView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContainer: UIView!
    @IBOutlet weak var creditBillDate: UILabel!
    @IBOutlet weak var repaymentDate: UILabel!
    
    @IBOutlet weak var lastSettlePayNum: UILabel!
    @IBOutlet weak var lastSettleCharge: UILabel!
    
    @IBOutlet weak var creditLines: UILabel!
    
    @IBOutlet weak var thisSettlePayNum: UILabel!
    @IBOutlet weak var thisSettleCharge: UILabel!
    
    @IBOutlet weak var surplusAmout: UILabel!
    
    var cardInfo: CardInfo!
    var cardPayInfos: (Float, Float, Float, Float)!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconBgView.layer.cornerRadius = iconBgView.bounds.width/2.0
        
        let index = Int(cardInfo.bankID)
        self.bankName.text = SCBank.Names[index]
        self.icon.image = SCBank.Icons[index]
        self.view.backgroundColor = SCBank.Colors[index]
        self.scrollView.backgroundColor = SCBank.Colors[index]
        self.scrollViewContainer.backgroundColor = SCBank.Colors[index]
        self.creditBillDate.text = "\(cardInfo.creditBillDate)号"
        self.repaymentDate.text = "\(cardInfo.repaymentWarningDay)号"
        self.lastSettlePayNum.text = "\(cardPayInfos.0)"
        self.lastSettleCharge.text = "\(cardPayInfos.1)"
        self.thisSettlePayNum.text = "\(cardPayInfos.2)"
        self.thisSettleCharge.text = "\(cardPayInfos.3)"
        self.creditLines.text = "\(cardInfo.creditLines)"
        self.surplusAmout.text = "\(Float(cardInfo.creditLines) - cardPayInfos.0 - cardPayInfos.2)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    @IBAction
    func repayment(sender: UIButton) {
        let alertVC = UIAlertController(title: "温馨提示", message: "请确保上期欠款已全部还清，确定已还清吗？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .destructive) { _ in
            let rs = PayRecordManager.repayment(bankID: self.cardInfo.bankID)
            if rs {
                showSuccessHud(title: "还款成功")
                self.lastSettlePayNum.text = "0"
                self.lastSettleCharge.text = "0"
                self.surplusAmout.text = "\(Float(self.cardInfo.creditLines) - self.cardPayInfos.2)"
            } else {
                showErrorHud(title: "还款失败，请退出重试")
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction
    func close(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
