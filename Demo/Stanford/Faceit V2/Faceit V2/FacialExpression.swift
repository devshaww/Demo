//
//  FacialExpression.swift
//  Faceit V2
//
//  Created by Shaw on 16/7/14.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//

struct FacialExpression {
    enum Eyes: Int {
        case open
        case closed
    }
    
    enum EyeBrows: Int {
        case relaxed
        case normal
        case furrowed
        
        func moreRelaxedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue - 1) ?? .relaxed
        }
        
        func moreFurrowedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue + 1) ?? .furrowed
        }
    }
    
    enum Mouth: Int {
        case frown
        case smirk
        case neutral
        case grin
        case smile
        
        func sadderMouth() -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .frown
        }
        
        func happierMouth() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
        
    }
    
    enum Wink: Int {
        case leftOpen
        case rightOpen
        
        func switchCase () -> Wink {
            if rawValue == 0 {
                return Wink(rawValue: rawValue + 1) ?? .leftOpen
            } else {
                return Wink(rawValue: rawValue - 1) ?? .rightOpen
            }
        }
    }
    
    var eyes: Eyes
    var eyeBrows: EyeBrows
    var mouth: Mouth
    var wink: Wink
}
