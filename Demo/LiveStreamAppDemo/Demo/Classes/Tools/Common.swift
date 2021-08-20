//
//  Common.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/3.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

let kScreenW: CGFloat = UIScreen.main.bounds.size.width
let kScreenH: CGFloat = UIScreen.main.bounds.size.height

var kStatusBarH: CGFloat {
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    if #available(iOS 11.0, *) {
        return window?.safeAreaInsets.top ?? 0
    } else {
        return 20
    }
}

let kNavBarH: CGFloat = 44
let kTabBarH: CGFloat = 44

let kLineOffset: CGFloat = 20
let kTopPadding: CGFloat = kStatusBarH + kNavBarH
