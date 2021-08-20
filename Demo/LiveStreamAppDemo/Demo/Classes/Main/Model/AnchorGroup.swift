//
//  AnchorGroup.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/7.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

class AnchorGroup: NSObject {
    
    // 该组对应的房间信息
    @objc var room_list: [[String: AnyObject]]? {
        didSet {
            guard let room_list = room_list else { return }
            for dic in room_list {
                anchors.append(AnchorModel(dic: dic))
            }
        }
    }
    
    // 标题
    @objc var tag_name: String = ""
    
    // icon
    @objc var icon_name: String = "home_header_normal"
    
    @objc var icon_url: String = ""
    
    lazy var anchors: [AnchorModel] = [AnchorModel]()
    
    override init() {
        
    }
    
    init(dic: [String : AnyObject]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
