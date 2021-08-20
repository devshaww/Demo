//
//  MainViewController.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/3.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVC("Home")
        addChildVC("Live")
        addChildVC("Follow")
        addChildVC("Profile")
    }
    
    fileprivate func addChildVC(_ storyName: String) {
        let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        addChild(childVC)
    }
}
 
