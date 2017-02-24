//
//  FaceView.swift
//  Happiness
//
//  Created by Shaw on 16/5/7.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//

import UIKit

protocol FaceViewDataSource: class {
    func smilinessForFaceView(_ sender: FaceView) -> Double?
}

@IBDesignable
class FaceView: UIView {
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    
    var faceCenter: CGPoint {
        return convert(center, from: superview)
    }
    
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    weak var dataSource: FaceViewDataSource?
    
    fileprivate struct scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    fileprivate enum Eye { case left, right }
    
    fileprivate func bezierPathForEye(_ whichEye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .left: eyeCenter.x -= eyeHorizontalSeparation / 2
        case .right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    
    // draw smile which takes fractionOfMaxSize(1 means full smile,-1 means full frown) as its argument
    fileprivate func bezierPathForSmile(_ fractionOfMaxSize: Double) -> UIBezierPath {
        let mouthWidth = faceRadius / scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(min(max(-1,fractionOfMaxSize),1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect)
    {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        
        facePath.lineWidth = lineWidth
        color.set() // set color for both stroke and fill,you could use setFill() or setStroke() to be more precise
        facePath.stroke()
        bezierPathForEye(.left).stroke()
        bezierPathForEye(.right).stroke()
        
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }
    

}
