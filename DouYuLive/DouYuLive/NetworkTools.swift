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
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.error ?? "error getting result")
                return
            }
            finishedCallback(result as AnyObject)
        }
        
    }

}
