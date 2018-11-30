//
//  SCProfileViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/27.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import LocalAuthentication

class SCProfileViewController: UITableViewController {
    
    var postrait: UIButton!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人资料"
        
        tableViewSetting()
    }
    
    func tableViewSetting() {
        
        /// headerView
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200.0))
        postrait = UIButton(frame: CGRect(x: 0, y: 0, width: 80.0, height: 80.0))
        postrait.layer.cornerRadius = postrait.bounds.width/2.0
        postrait.clipsToBounds = true
        postrait.imageView?.contentMode = .scaleAspectFit
        postrait.setImage(UIImage(named: "take_photo"), for: .normal)
        postrait.addTarget(self, action: #selector(modifyPostrait(sender:)), for: .touchUpInside)
        
        postrait.center = headerView.center
        headerView.addSubview(postrait)
        
        let lineView = UIView(frame: CGRect(x: 0, y: headerView.bounds.height - 30.0, width: view.bounds.width, height: 30.0))
        lineView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        headerView.addSubview(lineView)
        
        tableView.tableHeaderView = headerView
        
        /// footerView
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150.0))
        let saveBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50.0))
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.setTitleColor(UIColor(red: 193/255.0, green: 187/255.0, blue: 20/255.0, alpha: 1.0), for: .normal)
        saveBtn.addTarget(self, action: #selector(save(sender:)), for: .touchUpInside)
        
        let tLineView = UIView(frame: CGRect(x: 0, y: 30.0, width: view.bounds.width, height: 20.0))
        tLineView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        
        footerView.addSubview(saveBtn)
        footerView.addSubview(tLineView)
        saveBtn.center = footerView.center
        tableView.tableFooterView = footerView
    }
    
    @objc func modifyPostrait(sender: UIButton) {
        let photoVC = UIAlertController(title: nil, message: "设置头像", preferredStyle: .actionSheet)
        let takePhotoAcion = UIAlertAction(title: "拍照", style: .default) { _ in
            self.takePhoto(takePhoto: true)
        }
        let selectPhotoAction = UIAlertAction(title: "选择照片", style: .default) { _ in
            self.takePhoto(takePhoto: false)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        photoVC.addAction(takePhotoAcion)
        photoVC.addAction(selectPhotoAction)
        photoVC.addAction(cancelAction)
        self.present(photoVC, animated: true, completion: nil)
    }
    
    @objc func save(sender: UIButton) {
        
    }
    
    func touchIDOn(isOn: Bool) {
        if isOn {
            startTouchIDVerify()
        }
    }
}

/// 指纹识别
extension SCProfileViewController {
    func startTouchIDVerify() {
        if NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0 {
            showErrorHud(title: "该系统版本不支持TouchID")
            return
        }
        
        let context = LAContext()
        context.localizedFallbackTitle = "输入密码"
        
        var error: NSError?
        if context.canEvaluatePolicy(LAPolicy(rawValue: Int(kLAPolicyDeviceOwnerAuthenticationWithBiometrics))!, error: &error) {
            context.evaluatePolicy(LAPolicy(rawValue: Int(kLAPolicyDeviceOwnerAuthenticationWithBiometrics))!, localizedReason: "通过Home键验证已有指纹") { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        showSuccessHud(title: "验证成功")
                    } else {
                        showErrorHud(title: "验证失败!")
                    }
                }
            }
        } else {
            showErrorHud(title: "当前设备不支持TouchID")
        }
        
        if let _ = error {
            showErrorHud(title: "没有设置TouchID，请设置TouchID后再使用该功能")
        }
    }
}

/// 拍照和相册
extension SCProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func takePhoto(takePhoto: Bool) {

        PHPhotoLibrary.isAuthorized
            .skipWhile { $0 == false }
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { rs in
                let imagePicker = UIImagePickerController()
                imagePicker.modalPresentationStyle = .fullScreen
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                imagePicker.sourceType = takePhoto ? .camera : .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }).disposed(by: bag)

        PHPhotoLibrary.isAuthorized
            .distinctUntilChanged()
            .takeLast(1)
            .filter { $0 == false }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                let alertVC = UIAlertController(title: "温馨提示", message: "请到设置里开启SmartCard的相机/相册权限", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
                alertVC.addAction(cancelAction)
                self.present(alertVC, animated: true, completion: nil)
            }).disposed(by: bag)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.allowsEditing {
            postrait.setImage(info[UIImagePickerController.InfoKey.editedImage] as? UIImage, for: .normal)
        } else {
            postrait.setImage(info[UIImagePickerController.InfoKey.originalImage] as? UIImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension SCProfileViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as? SCProfileTableViewCell1  else {
                fatalError("Couldn't initial SCProfileTableViewCell1 with identifier Cell1")
            }
            cell.title.text = "昵称"
            cell.nickName.text = "archeLj"
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as? SCProfileTableViewCell2 else {
                fatalError("Couldn't initial SCProfileTableViewCell2 with identifier Cell2")
            }
            cell.title.text = "手势密码"
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as? SCProfileTableViewCell3 else {
                fatalError("Couldn't initial SCProfileTableViewCell3 with identifier Cell3")
            }
            cell.title.text = "指纹登录"
            cell.selectionStyle = .none
            cell.switcher.isOn = false
            cell.switchAction = touchIDOn
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let gestureVC: SCGesturePSWDViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
        self.navigationController?.pushViewController(gestureVC, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.endEditing(true)
    }
}
