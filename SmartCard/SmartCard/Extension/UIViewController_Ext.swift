//
//  UIViewController_Ext.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/20.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: StoryboardIdentifiable {}

var adapteKeyboardKey = 1000
var firstResponderKey = 1001

extension UIViewController {
    var adapteKeyboard: Bool {
        set {
            if newValue {
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            }
            objc_setAssociatedObject(self, &adapteKeyboardKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, &adapteKeyboardKey) as? Bool {
                return rs
            } else {
                return false
            }
        }
    }
    
    var firstResponder: UITextField? {
        set {
            objc_setAssociatedObject(self, &firstResponderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &firstResponderKey) as? UITextField
        }
    }
}

extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if textField.maxLength > 0 {
                if text.count >= textField.maxLength {
                    textField.text = String(text.prefix(textField.maxLength - 1))
                }
            }
        }
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        firstResponder = textField
        return true
    }
    
    @objc func keyboardShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo as? Dictionary<String, Any> else {
            return
        }
        guard let keyBoardRect = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
            return
        }
        
        guard let firstResponder = firstResponder else {
            return
        }
        
        let frameInView = firstResponder.convert(firstResponder.frame, to: view)
        let firstResponderMaxY = frameInView.maxY
        let keyBoardMinY = keyBoardRect.minY
        if firstResponderMaxY > keyBoardMinY {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -(firstResponderMaxY - keyBoardMinY + 15.0))
            }, completion: nil)
        }
    }
    
    @objc func keyboardHidden(notification: NSNotification) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
