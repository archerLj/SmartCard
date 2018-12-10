//
//  SCProfileTableViewCell1.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/27.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SCProfileTableViewCell1: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var brefIntroduction: UITextField!
    let bag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        brefIntroduction.layer.borderColor = UIColor.white.cgColor
        brefIntroduction.layer.borderWidth = 3.0
    }
    
    func brefIntroChanged(action: ((String?) -> Void)?) {
        if let ac = action {
            brefIntroduction.rx.text.asObservable().subscribe(onNext: { input in
                ac(input)
            }).disposed(by: bag)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
