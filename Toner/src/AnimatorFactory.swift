//
//  AnimatorFactory.swift
//  Toner
//
//  Created by LiLi Kazine on 2019/1/18.
//

import UIKit

class AnimatorFactory: NSObject {
    
    static func scale(duration: TimeInterval, layer: CALayer, transform: CATransform3D) -> UIViewPropertyAnimator {
        
        let animator = UIViewPropertyAnimator(duration: duration, controlPoint1: CGPoint(x: 0.57, y: -0.4), controlPoint2: CGPoint(x: 0.96, y: 0.87))
        
        animator.addAnimations {
//            layer.transform = CATransform3DMakeScale(45, 45, 1.0)
            layer.opacity = 0.3
        }
        return animator
    }

}
