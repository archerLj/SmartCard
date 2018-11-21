//
//  SCColors.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/13.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import UIKit

struct SCBank {
    
    static let Colors = [
        Color.gongHang,
        Color.zhaoHang,
        Color.jianHang,
        Color.youZheng,
        Color.nongHang,
        Color.jiaoHang,
        Color.zhongXin,
        Color.minSheng,
        Color.zhongHang,
        Color.puFa,
        Color.pingAn,
        Color.guangFa
    ]
    
    static let Names = [
        Name.gongHang,
        Name.zhaoHang,
        Name.jianHang,
        Name.youZheng,
        Name.nongHang,
        Name.jiaoHang,
        Name.zhongXin,
        Name.minSheng,
        Name.zhongHang,
        Name.puFa,
        Name.pingAn,
        Name.guangFa
    ]
    
    static let Icons = [
        Icon.gongHang,
        Icon.zhaoHang,
        Icon.jianHang,
        Icon.youZheng,
        Icon.nongHang,
        Icon.jiaoHang,
        Icon.zhongXin,
        Icon.minSheng,
        Icon.zhongHang,
        Icon.puFa,
        Icon.pingAn,
        Icon.guangFa
    ]
    
    struct Color {
        static let gongHang = UIColor(red: 237/255.0, green: 50/255.0, blue: 55/255.0, alpha: 1.0)
        static let zhaoHang = UIColor(red: 237/255.0, green: 50/255.0, blue: 55/255.0, alpha: 1.0)
        static let jianHang = UIColor(red: 41/255.0, green: 80/255.0, blue: 151/255.0, alpha: 1.0)
        static let youZheng = UIColor(red: 45/255.0, green: 135/255.0, blue: 81/255.0, alpha: 1.0)
        static let nongHang = UIColor(red: 0, green: 130/255.0, blue: 108/255.0, alpha: 1.0)
        static let jiaoHang = UIColor(red: 62/255.0, green: 64/255.0, blue: 149/255.0, alpha: 1.0)
        static let zhongXin = UIColor(red: 237/255.0, green: 50/255.0, blue: 55/255.0, alpha: 1.0)
        static let minSheng = UIColor(red: 92/255.0, green: 164/255.0, blue: 122/255.0, alpha: 1.0)
        static let zhongHang = UIColor(red: 185/255.0, green: 58/255.0, blue: 62/255.0, alpha: 1.0)
        static let puFa = UIColor(red: 62/255.0, green: 64/255.0, blue: 149/255.0, alpha: 1.0)
        static let pingAn = UIColor(red: 234/255.0, green: 85/255.0, blue: 4/255.0, alpha: 1.0)
        static let guangFa = UIColor(red: 118/255.0, green: 37/255.0, blue: 43/255.0, alpha: 1.0)
    }
    
    struct Name {
        static let gongHang = "工商银行"
        static let zhaoHang = "招商银行"
        static let jianHang = "建设银行"
        static let youZheng = "中国邮政银行"
        static let nongHang = "农业银行"
        static let jiaoHang = "交通银行"
        static let zhongXin = "中信银行"
        static let minSheng = "民生银行"
        static let zhongHang = "中国银行"
        static let puFa = "浦发银行"
        static let pingAn = "中国平安银行"
        static let guangFa = "广发银行"
    }
    
    struct Icon {
        static let gongHang = UIImage(named: "icon_gonghang")!
        static let zhaoHang = UIImage(named: "icon_zhaohang")!
        static let youZheng = UIImage(named: "icon_youzheng")!
        static let jianHang = UIImage(named: "icon_jianhang")!
        static let jiaoHang = UIImage(named: "icon_jiaohang")!
        static let nongHang = UIImage(named: "icon_nonghang")!
        static let zhongXin = UIImage(named: "icon_zhongxin")!
        static let minSheng = UIImage(named: "icon_minsheng")!
        static let guangFa = UIImage(named: "icon_guangfa")!
        static let zhongHang = UIImage(named: "icon_zhonghang")!
        static let pingAn = UIImage(named: "icon_pingan")!
        static let puFa = UIImage(named: "icon_pufa")!
    }
}
