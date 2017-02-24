//
//  AnchorModel.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/9.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

class AnchorModel: NSObject {
    
    var room_id: Int = 0
    
    var vertical_src: String = ""
    
    var isVertical: Int = 0
    
    var room_name: String = ""
    
    var nickname: String = ""
    
    var online: Int = 0
    
    var anchor_city: String = ""
    
    init(dic: [String: AnyObject]) {
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
