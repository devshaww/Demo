//
//  AnchorModel.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/9.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

class AnchorModel: NSObject {
    
    @objc var room_id: Int = 0
    
    @objc var vertical_src: String = ""
    
    @objc var isVertical: Int = 0
    
    @objc var room_name: String = ""
    
    @objc var nickname: String = ""
    
    @objc var online: Int = 0
    
    @objc var anchor_city: String = ""
    
    init(dic: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
