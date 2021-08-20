//
//  FaceView.swift
//  Faceit V2
//
//  Created by Shaw on 16/7/13.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
//    Until you've fully initialized it,you can not use its properties like bounds or something.
    
//    let skullRadius = min(bounds.size.width,bounds.size.height) / 2
//    let skullCenter = CGPoint(x: bounds.midX, y: bounds.midY)
    var mouthCurvature: Double = 1 // 1:ecstatic  -1:full frown
    var eyesOpen: Bool = true
    var eyeBrowTilt: Double = 0.5    //1:fully relaxed    -1:full frown
    var scale: CGFloat = 0.90
    var lineWidth: CGFloat = 5.0
    var color: UIColor = UIColor.blue
    var switchWink: Bool = false { didSet { setNeedsDisplay() } }
    var winkType: Wink = .leftOpen
    
    enum Wink { case leftOpen, rightOpen }
    
    fileprivate var skullRadius: CGFloat {
        return min(bounds.size.width,bounds.size.height) / 2 * scale
    }
    
    fileprivate var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    fileprivate struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 5
    }
    
    fileprivate enum Eye {case left, right}
    
    fileprivate func pathForCircleCenteredAtPoint(_ midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    fileprivate func pathForBrow(_ eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
        case .left:
            tilt *= -1.0
        case .right:
            break
        }
        var browCenter = getEyeCenter(eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(min(max(tilt, -1), 1)) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    fileprivate func getEyeCenter(_ eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .left:
            eyeCenter.x -= eyeOffset
        case .right:
            eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    fileprivate func pathForEye(_ eye: Eye, _: Wink) -> UIBezierPath {
        print("pathForEye")
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye)
        func getPath() -> UIBezierPath {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
        if eyesOpen {
            if !switchWink {
                return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
            } else {
                switch winkType {
                case .leftOpen:
                    switch eye {
                    case .left:
                        return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
                    case .right:
                        return getPath()
                    }
                case .rightOpen:
                    switch eye {
                    case .left:
                        return getPath()
                    case .right:
                        return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
                    }
                    
                }
            }
        } else {
            return getPath()
        }
    }
    
    fileprivate func pathForMouth() -> UIBezierPath {
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        // minX:the most left x of the rect
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
    
        let smileOffset = CGFloat(min(max(mouthCurvature, -1), 1)) * mouthHeight
        
        let cp1 = CGPoint(x: mouthRect.minX + mouthWidth / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthWidth / 3, y: mouthRect.minY + smileOffset)
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        pathForCircleCenteredAtPoint(skullCenter, withRadius: skullRadius).stroke()
        pathForEye(.left, winkType).stroke()
        pathForEye(.right, winkType).stroke()
        pathForBrow(.left).stroke()
        pathForBrow(.right).stroke()
        pathForMouth().stroke()

        
    }


}
