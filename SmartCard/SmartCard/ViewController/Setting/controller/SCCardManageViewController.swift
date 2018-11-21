//
//  SCCardManageViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/20.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCCardManageViewController: UIViewController {
    
    @IBOutlet weak var cardCount: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    let cardNumbers = ["1234567890098765",
                     "1234567890096753",
                     "1234567890090159",
                     "1234567890092341",
                     "1234567890099845",
                     "1234567890090987",
                     "1234567890099090",
                     "1234567890096342",
                     "1234567890098709",
                     "1234567890091123",
                     "1234567890096567",
                     "1234567890098323"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "信用卡管理"
        
        cardCount.text = "信用卡(12)"
    }
    
    @IBAction func addNewCard(_ sender: UIButton) {
        let addCreditCardVC: SCAddCreditCardViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
        self.navigationController?.pushViewController(addCreditCardVC, animated: true)
    }
    
}

extension SCCardManageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SCBank.Names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.className(cs: SCCardManageTableViewCell.self), for: indexPath) as? SCCardManageTableViewCell else {
            fatalError("Couldn't inital SCCardmanageTableViewCell with identifier: \(String.className(cs: SCCardManageTableViewCell.self))")
        }
     
        cell.selectionStyle = .none
        cell.configuer(bankIcon: SCBank.Icons[indexPath.row],
                       bankName: SCBank.Names[indexPath.row],
                       cardNum: cardNumbers[indexPath.row],
                       bankTheme: SCBank.Colors[indexPath.row])
        
        return cell
    }
}
