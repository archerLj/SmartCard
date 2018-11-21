//
//  SCTextField.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/21.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        inputAccessoryViewSetting()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inputAccessoryViewSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func inputAccessoryViewSetting() {
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 44.0
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        view.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        
        let doneBtn = UIButton(frame: CGRect(x: width - 80.0, y: 0, width: 60.0, height: height))
        doneBtn.setTitle("完成", for: .normal)
        doneBtn.setTitleColor(UIColor.black, for: .normal)
        doneBtn.addTarget(self, action: #selector(doneAction(sender:)), for: .touchUpInside)
        view.addSubview(doneBtn)
        
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 1.0))
        topLine.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        view.addSubview(topLine)
        
        inputAccessoryView = view
    }
    
    @objc func doneAction(sender: UIButton) {
        self.resignFirstResponder()
    }
}
