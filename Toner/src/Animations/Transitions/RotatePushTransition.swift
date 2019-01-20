
//
//  RotatePushTransition.swift
//  Toner
//
//  Created by LiLi Kazine on 2019/1/20.
//

import UIKit

class RotatePushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationDuration: TimeInterval = 0.4
    
    var operation: UINavigationController.Operation?
    
    var pushing: Bool {
        return operation == .push
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from), let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(true)
            return
        }

        toView.layer.shouldRasterize = true
        toView.layer.rasterizationScale = UIScreen.main.scale
        
        let size: CGSize = fromView.frame.size

        var identity = CATransform3DIdentity
        fromView.layer.transform = identity
        toView.layer.transform = identity
        identity.m34 = -1.0/1000
        
        containerView.insertSubview(toView, belowSubview: fromView)

        fromView.layer.anchorPoint.x = pushing ? 1.0 : 0.0
        fromView.layer.frame.origin.x = 0
        toView.layer.anchorPoint.x = pushing ? 0.0 : 1.0
        
        let toViewOffsetX = pushing ? size.width : -size.width
        
        toView.frame.origin.x = fromView.frame.origin.x + toViewOffsetX
        
        let prepareAngle: CGFloat = pushing ? .pi * 0.5 : .pi * -0.5
        let prepareRotation = CATransform3DRotate(identity, prepareAngle, 0.0, 1.0, 0.0)
        toView.layer.transform = prepareRotation
        toView.layer.opacity = 0.2
        let move = pushing ? -size.width : size.width
        let offset = CATransform3DMakeTranslation(move, 0.0, 0.0)
        let rotateOutAngle: CGFloat = pushing ? .pi * -0.5 : .pi * 0.5
        let rotationOut = CATransform3DRotate(identity, rotateOutAngle, 0.0, 1.0, 0.0)
        let rotationIn = CATransform3DRotate(identity, 0.0, 0.0, 1.0, 0.0)
        let transformIn = CATransform3DConcat(rotationIn, offset)
        let transformOut = CATransform3DConcat(rotationOut, offset)
        
        UIView.animate(withDuration: animationDuration, animations: {
            toView.layer.transform = transformIn
            toView.layer.opacity = 1.0
            fromView.layer.transform = transformOut
            fromView.layer.opacity = 0.2
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            toView.layer.shouldRasterize = false
            if !self.pushing {
                toView.layer.anchorPoint.x = 1.0
//                print("toView frame after: \(toView.frame)")
//                print("fromView frame after: \(fromView.frame)")

            }
        }
        
        
        
        
    }
    

    
    
}
