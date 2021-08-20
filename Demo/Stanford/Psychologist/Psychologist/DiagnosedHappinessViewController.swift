//
//  DiagnosedHappinessViewController.swift
//  Psychologist
//
//  Created by Shaw on 16/5/15.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//

import UIKit

class DiagnosedHappinessViewController: HappinessViewController, UIPopoverPresentationControllerDelegate {
    
    override var happiness: Int {
        didSet {
            diagnosticHistory += [happiness]
        }
    }
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var diagnosticHistory: [Int] {
        set {
            defaults.setObject(newValue, forKey: History.DefaultsKey)
        }
        get {
            return defaults.objectForKey(History.DefaultsKey) as? [Int] ?? []
        }
    }
    
    private struct History {
        static let SegueIdentifier = "Show Diagnostic History"
        static let DefaultsKey = "DiagnosedHappinessViewController.History"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case History.SegueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController {
                    if let ppv = tvc.popoverPresentationController {
                        ppv.delegate = self
                    }
                    tvc.text = "\(diagnosticHistory)"
                }
            default:
                break;
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
