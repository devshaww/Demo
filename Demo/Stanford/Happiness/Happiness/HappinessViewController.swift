//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Shaw on 16/5/7.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {
    
    fileprivate struct Constants {
        static let HappinessGestureScale: CGFloat = 4
    }

    @IBAction func changeHappiness(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .ended: fallthrough
        case .changed:
            let translation = gesture.translation(in: faceView)
            // 往上 y为负即happinessChange为正 往下 y为正即happinessChange为负
            let happinessChange = -Int(translation.y / Constants.HappinessGestureScale)
            if happinessChange != 0 {
                // 往上 happiness减小 往下 happiness增大
                happiness -= happinessChange
                gesture.setTranslation(CGPoint.zero, in: faceView)
            }
        default: break
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(scale(_:))))
        }
    }
    
    func scale(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            faceView.scale *= gesture.scale
            gesture.scale = 1  //
        }
    }
    
    var happiness: Int = 75 {  // 1 = sad and 100 = ecstatic
        didSet {
            happiness = min(max(1, happiness),100)
            updateUI()
        }
    }
    
    func smilinessForFaceView(_ sender: FaceView) -> Double? {
        return Double(happiness - 50) / 50
    }
    
    func updateUI() {
        faceView.setNeedsDisplay()
    }
}
