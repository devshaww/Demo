//
//  UIBarButtonItem+extension.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/3.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName: String, hImageName: String, size: CGSize) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: hImageName), for: .highlighted)
        btn.frame = CGRect(origin: .zero, size: size)
        
        self.init(customView: btn)
    }
}
