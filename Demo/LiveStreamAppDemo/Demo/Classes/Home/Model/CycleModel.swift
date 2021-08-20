//
//  CycleModel.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/11.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import Foundation

class CycleModel: NSObject {

    @objc var title: String = ""
    
    @objc var pic_url: String = ""
    
    @objc var room: [String: AnyObject]? {
        didSet {
            guard let room = room else { return }
            anchor = AnchorModel(dic: room)
        }
    }
    
    @objc var anchor: AnchorModel?
    
    init(dic: [String: AnyObject]) {
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
