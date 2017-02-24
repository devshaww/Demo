//
//  ViewController.swift
//  Cassini
//
//  Created by Shaw on 16/5/21.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ivc = segue.destinationViewController as? ImageViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "wd1":
                    ivc.imageURL = DemoURL.wedding.wd1
                    ivc.title = identifier
                case "wd2":
                    ivc.imageURL = DemoURL.wedding.wd2
                    ivc.title = identifier
                case "wd3":
                    ivc.imageURL = DemoURL.wedding.wd3
                    ivc.title = identifier
                default:
                    break
                }
            }
        }
        
    }

}

