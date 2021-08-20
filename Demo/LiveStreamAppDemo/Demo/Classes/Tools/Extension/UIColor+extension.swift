//
//  UIColor+extension.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/4.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}
