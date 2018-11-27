//
//  SCNewPlanViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/26.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit
import RxSwift

class SCNewPlanViewController: UIViewController {
    
    fileprivate var addSubject = PublishSubject<PayPlan>()
    var addResult: Observable<PayPlan> {
        return addSubject.asObservable()
    }
    
    @IBOutlet weak var startHour: UIButton!
    @IBOutlet weak var endHour: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var payPlan: PayPlan?
    var maskView: UIView!
    var sellerConfigures:[SellerConfigure] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        maskView = UIView(frame: view.bounds)
        
        startHour.layer.borderWidth = 1.0
        startHour.layer.borderColor = UIColor.gray.cgColor
        endHour.layer.borderWidth = 1.0
        endHour.layer.borderColor = UIColor.gray.cgColor

        getAllSellerConfiger()
        if let plan = payPlan {
            initSetting(plan: plan)
        }
    }
    
    func initSetting(plan: PayPlan) {
        
        self.startHour.setTitle(String(plan.startHour), for: .normal)
        self.endHour.setTitle(String(plan.endHour), for: .normal)
        self.startHour.isEnabled = false
        self.endHour.isEnabled = false
        
        let sellerNames = plan.sellerNames!.components(separatedBy: "///")
        for configure in sellerConfigures {
            for sellerName in sellerNames {
                if configure.sellerName == sellerName {
                    configure.sellerName = "C" + sellerName
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func getAllSellerConfiger() {
        if let rs = SellerConfigureManager.getAll() {
            self.sellerConfigures.append(contentsOf: rs)
            self.tableView.reloadData()
        }
    }
    
    deinit {
        addSubject.onCompleted()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        guard let start = startHour.titleLabel?.text, !start.isEmpty,
            let end = endHour.titleLabel?.text, !end.isEmpty else {
            showErrorHud(title: "时间段不合法")
            return
        }
        
        if Int(start)! > Int(end)! {
            showErrorHud(title: "时间段不合法")
            return
        }
        
        var selected = false
        var sellerNames: String = ""
        for sellerConfigure in self.sellerConfigures {
            if sellerConfigure.sellerName!.starts(with: "C") {
                selected = true
                sellerNames += String(sellerConfigure.sellerName!.dropFirst())
                sellerConfigure.sellerName = String(sellerConfigure.sellerName!.dropFirst())
                sellerNames += "///"
            }
        }
        
        if !selected {
            showErrorHud(title: "请选择商户类型")
        }
        
        sellerNames = String(sellerNames.dropLast(3))
        
        var result: PayPlan
        if let plan = payPlan {
            guard let rs = PayPlanManager.update(startHour: plan.startHour, endHour: plan.endHour, sellerNames: sellerNames) else {
                showErrorHud(title: "保存失败")
                return
            }
            result = rs
        } else {
            guard let rs = PayPlanManager.save(startHour: Int16(start)!, endHour: Int16(end)!, sellerNames: sellerNames) else {
                showErrorHud(title: "保存失败")
                return
            }
            result = rs
        }
        
        showSuccessHud(title: "保存成功")
        addSubject.onNext(result)
        addSubject.onCompleted()
        delay(3.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func startHourAction(_ sender: UIButton) {
        showHourSelectView(sender: sender)
    }
    
    
    @IBAction func endHourAction(_ sender: UIButton) {
        showHourSelectView(sender: sender)
    }
    
    func showHourSelectView(sender: UIButton) {
        
        self.view.addSubview(maskView)
        maskView.backgroundColor = UIColor.clear
        
        let scHourVC = SCDayTableViewController()
        scHourVC.maxDay = 24
        scHourVC.titleInfo = (sender === startHour) ? "请选择开始时间" : "请选择结束时间"
        
        scHourVC.willMove(toParent: self)
        self.addChild(scHourVC)
        self.view.addSubview(scHourVC.view)
        scHourVC.didMove(toParent: self)
        
        let hourViewH: CGFloat = 300.0
        scHourVC.view.frame = CGRect(x: 0, y: view.bounds.height - hourViewH, width: view.bounds.width, height: hourViewH)
        scHourVC.view.transform = CGAffineTransform(translationX: 0, y: hourViewH)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
            scHourVC.view.transform = .identity
            self.maskView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        }, completion: nil)
        
        _ = scHourVC.selectDay.subscribe(onNext: { hour in
        })
        _ = scHourVC.selectDay.subscribe(onNext: { hour in
            sender.setTitle(String(hour), for: .normal)
        }, onCompleted: {
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: .curveEaseIn, animations: {
                scHourVC.view.transform = CGAffineTransform(translationX: 0, y: hourViewH)
                self.maskView.backgroundColor = UIColor.clear
            }, completion: { _ in
                self.maskView.removeFromSuperview()
            })
        })
    }
}

extension SCNewPlanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sellerConfigures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SCNewPlanTableViewCell else {
            fatalError("Couldn't initial SCNewPlanTableViewCell with identifier Cell")
        }
        
        let sellerConfigure = self.sellerConfigures[indexPath.row]
        cell.configure(sellerConfigure: sellerConfigure)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sellerConfiure = self.sellerConfigures[indexPath.row]
        if sellerConfiure.sellerName!.starts(with: "C") {
            sellerConfiure.sellerName = String((sellerConfiure.sellerName?.dropFirst())!)
        } else {
            sellerConfiure.sellerName = "C" + sellerConfiure.sellerName!
        }
        tableView.reloadData()
    }
}
