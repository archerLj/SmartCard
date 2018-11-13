//
//  FlushViewController.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/13.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import UIKit

class FlushViewController: UIViewController {
    
    var flushGridView: FlushGridView!
    var logoView: LogoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        flushGridView = FlushGridView(itemFileName: "flush_item", frame: view.bounds)
        view.addSubview(flushGridView)
        flushGridView.startAnimting()
        
        
        let logoImage = UIImage(named: "appIcon_smart")!
        logoView = LogoView()
        logoView.frame = CGRect(x: 0, y: 0, width: logoImage.size.width, height: logoImage.size.height)
        logoView.maskImage = logoImage
        view.addSubview(logoView)
        logoView.center = view.center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
