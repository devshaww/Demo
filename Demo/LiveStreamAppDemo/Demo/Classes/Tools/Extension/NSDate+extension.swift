//
//  NSDate+extension.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/7.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import Foundation

extension NSDate {
    class func currentTime() -> String {
        let date = NSDate()
        let interval = Int(date.timeIntervalSince1970)
        return "\(interval)"
    }
}
