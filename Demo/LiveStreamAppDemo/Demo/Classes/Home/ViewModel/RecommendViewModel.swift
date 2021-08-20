//
//  RecommendViewModel.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/7.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import Foundation
import Alamofire

class RecommendViewModel {
    // 第3-12组相关
    lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()
    
    // 第1组
    fileprivate lazy var bigDataGroup: AnchorGroup = AnchorGroup()
    
    // 第2组
    fileprivate lazy var prettyGroup: AnchorGroup = AnchorGroup()
    
    lazy var cycleModels: [CycleModel] = [CycleModel]()
    
}

// MARK: - 网络请求
extension RecommendViewModel {
    
    func requestData(completionHandler: @escaping () -> () ) {
        
        let parameters = ["time": NSDate.currentTime()]
        
        let dispatchGroup = DispatchGroup()
        // 1. 请求推荐数据
        // https://capi.douyucdn.cn/api/v1/getbigDataRoom?time=1474252024  https://capi.douyucdn.cn/api/v1/getbigDataRoom?time=1629203611
        dispatchGroup.enter()
        NetworkTools.requestData(type: .GET, URLString: "https://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: parameters) { (res) in
            guard let res = res as? [String: AnyObject] else { return }
            
            guard let dataList = res["data"] as? [[String: AnyObject]] else { return }
            
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            
            for dic in dataList {
                let anchor = AnchorModel(dic: dic)
                self.bigDataGroup.anchors.append(anchor)
            }
//            print("1组\(dataList.count)个数据获取完毕")
            dispatchGroup.leave()

        }
        
        // 2. 颜值数据
        // https://capi.douyucdn.cn/api/v1/getVerticalRoom?limit=4&offset=0&time=1474252024
//        dispatchGroup.enter()
//        NetworkTools.requestData(type: .GET, URLString: "https://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result) in
//            guard let result = result as? [String: AnyObject] else { return }
//
//            guard let dataArray = result["data"] as? [[String: AnyObject]] else { return }
//
//            self.prettyGroup.tag_name = "颜值"
//            self.prettyGroup.icon_name = "home_header_phone"
//
//            for dic in dataArray {
//                let anchor = AnchorModel(dic: dic)
//                self.prettyGroup.anchors.append(anchor)
//            }
//            dispatchGroup.leave()
//        }
        
        // 3. 后面的游戏数据
        // https://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1474252024
        dispatchGroup.enter()
        NetworkTools.requestData(type: .GET, URLString: "https://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (result) in
            guard let result = result as? [String: AnyObject] else { return }

            guard let dataList = result["data"] as? [[String: AnyObject]] else { return }

            for dic in dataList {
                let group = AnchorGroup(dic: dic)
                // AnchorGroup的room_list被设置时出问题
                // 因为取到的数据只能先以[[String: AnyObject]]接收 而不能直接将room_list设置成[AnchorModel]
                self.anchorGroups.append(group)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
//            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            completionHandler()
        }
    }
    
    
    // 请求无限轮播数据
    
    // http://www.douyutv.com/api/v1/slide/6
    func requestCycleData(completionHandler: @escaping () -> ()) {
        NetworkTools.requestData(type: .GET, URLString: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version":"2.300"]) { (result) in
            guard let result = result as? [String: AnyObject] else { return }

            guard let dataList = result["data"] as? [[String: AnyObject]] else { return }

            for dic in dataList {
                // KVC字典转模型
                let model = CycleModel(dic: dic)
                self.cycleModels.append(model)
            }
            // 记得调用 不然值传不过去
            print("轮播组\(dataList.count)个数据")
            completionHandler()
        }
    }
    
}
