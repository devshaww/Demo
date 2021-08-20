//
//  NetworkTools.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/7.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import Foundation
import Alamofire

enum MethodType {
    case GET
    case POST
}

class NetworkTools {
    
    class func requestData(type: MethodType, URLString: String, parameters: [String: Any]? = nil, finishedCallback: @escaping (_ result: AnyObject) -> ()) {
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        AF.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            guard let data = response.value else {
                print(response.error ?? "Alamofire Data Fetching Error")
                return
            }
            finishedCallback(data as AnyObject)
        }
            
    }
        
}
