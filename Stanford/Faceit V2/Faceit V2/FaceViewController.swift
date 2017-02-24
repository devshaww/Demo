//
//  ViewController.swift
//  Faceit V2
//
//  Created by Shaw on 16/7/13.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    var expression = FacialExpression(eyes: .open, eyeBrows: .normal, mouth: .smile, wink: .rightOpen) {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            updateUI()
        }
    }
    
    
    fileprivate func updateUI() {
        print("updateUI")
        switch expression.eyes {
        case .open:
            faceView.eyesOpen = true
        case .closed:
            faceView.eyesOpen = false
        }
        
        switch expression.wink {
        case .leftOpen:
            faceView.switchWink = true
            faceView.winkType = .leftOpen
        case .rightOpen:
            faceView.switchWink = true
            faceView.winkType = .rightOpen
        }

    }


}

