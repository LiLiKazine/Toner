//
//  UIBezierPathExtension.swift
//  Toner
//
//  Created by LiLi Kazine on 2019/1/18.
//

import UIKit

extension UIBezierPath {
    
    func starPathInRect(rect: CGRect){
        
        let starExtrusion:CGFloat = 30.0
        
        let center = CGPoint(x: rect.origin.x + rect.width / 2.0, y: rect.origin.y + rect.height / 2.0)
        
        let pointsOnStar = 5
//            + arc4random() % 10
        
        var angle:CGFloat = -CGFloat(.pi / 2.0)
        let angleIncrement = CGFloat(.pi * 2.0 / Double(pointsOnStar))
        let radius = rect.width / 2.0
        
        var firstPoint = true
        
        for _ in 1...pointsOnStar {
            
            let point = pointFrom(angle: angle, radius: radius, offset: center)
            let nextPoint = pointFrom(angle: angle + angleIncrement, radius: radius, offset: center)
            let midPoint = pointFrom(angle: angle + angleIncrement / 2.0, radius: starExtrusion, offset: center)
            
            if firstPoint {
                firstPoint = false
                self.move(to: point)
            }
            
            self.addLine(to: midPoint)
            self.addLine(to: nextPoint)
            
            angle += angleIncrement
        }
        
        self.close()
        
//        return path
    }
    
    func pointFrom(angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
        return CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y)
    }
    
  
    
}
