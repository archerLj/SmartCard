//
//  SCMainTabBarViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/19.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class SCMainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor(red: 81/255.0, green: 81/255.0, blue: 81/255.0, alpha: 1.0)
        tabBar.unselectedItemTintColor = UIColor(red: 112/255.0, green: 112/255.0, blue: 112/255.0, alpha: 1.0)
        
        let cardVC: SCCreditCardViewController = UIStoryboard.storyboard(storyboard: .Card).initViewController()
        cardVC.tabBarItem.image = UIImage(named: "tab_card_normal")
        cardVC.tabBarItem.selectedImage = UIImage(named: "tab_card_selected")
        cardVC.tabBarItem.title = "信用卡"
        
        
        let historyVC: SCHistoryViewController = UIStoryboard.storyboard(storyboard: .History).initViewController()
        historyVC.tabBarItem.image = UIImage(named: "tab_history_normal")
        historyVC.tabBarItem.selectedImage = UIImage(named: "tab_history_selected")
        historyVC.tabBarItem.title = "历史记录"
        
        
        let settingVC: SCSettingViewController = UIStoryboard.storyboard(storyboard: .Setting).initViewController()
        settingVC.tabBarItem.image = UIImage(named: "tab_setting_normal")
        settingVC.tabBarItem.selectedImage = UIImage(named: "tab_setting_selected")
        settingVC.tabBarItem.title = "设置"
        
        let navCard = UINavigationController(rootViewController: cardVC)
        let navHistory = UINavigationController(rootViewController: historyVC)
        let navSetting = UINavigationController(rootViewController: settingVC)
        navCard.delegate = self
        navHistory.delegate = self
        navSetting.delegate = self
        
        
        self.viewControllers = [navCard, navHistory, navSetting]
    }
}

extension SCMainTabBarViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
}
