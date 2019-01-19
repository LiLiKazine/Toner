

//
//  RotateUpwardsTransition.swift
//  Toner
//
//  Created by LiLi Kazine on 2019/1/19.
//

import UIKit

class RotatePresentTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    let animationDuration: TimeInterval = 0.4
    
    var presenting: Bool = true
    
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from), let toView = transitionContext.view(forKey: .to) else {
            return
        }
        
        let size:CGSize = fromView.frame.size
        
        var identity = CATransform3DIdentity
        fromView.layer.transform = identity
        toView.layer.transform = identity
        identity.m34 = -1.0/1000
        
        container.insertSubview(toView, aboveSubview: fromView)
   
        fromView.layer.anchorPoint.y = presenting ? 1.0: 0.0
        fromView.layer.frame.origin.y = 0
        toView.layer.anchorPoint.y = presenting ? 0.0 : 1.0
        
        let toViewOffsetY = presenting ? size.height : -size.height
        
        toView.frame.origin.y = fromView.frame.origin.y + toViewOffsetY
//        print("fy: \(fromView.frame.origin.y)")
//        print("offsetY: \(toViewOffsetY)")
//        print("ty: \(toView.frame.origin.y)")
        
        print("fromView frame before: \(fromView.frame)")
        print("toView frame before: \(toView.frame)")

        let prepareAngle: CGFloat = presenting ? .pi * -0.5 : .pi * 0.5
        let prepareRotation = CATransform3DRotate(identity, prepareAngle, 1.0, 0.0, 0.0)
        toView.layer.transform = prepareRotation
        toView.layer.opacity = 0.2
        print("toView frame prepare: \(toView.frame)")
        let move = presenting ? -size.height : size.height
        print("move: \(move)")
        let offset = CATransform3DMakeTranslation(0.0, move, 0.0)
        let rotateOutAngle: CGFloat = presenting ? .pi * 0.5 : .pi * -0.5
        let rotationOut = CATransform3DRotate(identity, rotateOutAngle, 1.0, 0.0, 0.0)
        let rotationIn = CATransform3DRotate(identity, 0.0, 1.0, 0.0, 0.0)

        let transformIn = CATransform3DConcat(rotationIn, offset)
        let transformOut =  CATransform3DConcat(rotationOut, offset)

        UIView.animate(withDuration: animationDuration, animations: {
            toView.layer.transform = transformIn
            toView.layer.opacity = 1.0
            fromView.layer.transform = transformOut
            fromView.layer.opacity = 0.2
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if !self.presenting {
                //TODO: Do not know wht exactly I have to add this, yet it worked.
                toView.layer.anchorPoint.y = 2.0
            }
            print("toView frame after: \(toView.frame)")
            print("fromView frame after: \(fromView.frame)")

        }
        
        
    }
    
    func animationEnded(_ transitionCompleted: Bool) {

        print("ended")
        
    }
   

}
