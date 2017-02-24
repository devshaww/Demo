//
//  ViewController.swift
//  Psychologist
//
//  Created by Shaw on 16/5/9.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {

    @IBAction func nothing(sender: UIButton) {
        performSegueWithIdentifier("nothing", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // When you're preparing,the outlet(which is faceView here) has not been set
        var destination: UIViewController? = segue.destinationViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController  // top of the stack
        }
        if let hvc = destination as? HappinessViewController {
            if let identifier = segue.identifier {
                switch identifier{
                case "happy":
                    hvc.happiness = 100
                case "sad":
                    hvc.happiness = 1
                default:
                    hvc.happiness = 50
                }
            }
        }
    }

}

