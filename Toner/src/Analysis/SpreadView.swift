//
//  SpreadView.swift
//  Toner
//
//  Created by LiLi Kazine on 2019/1/25.
//

import UIKit
import ChameleonFramework

class SpreadView: UIView {
    
    let colors: [UIColor]
    
    init(frame: CGRect, colors: [UIColor]) {
        self.colors = colors
        
        
        
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let size = rect.size
        let secWidth = size.width / 3
        let secHeight = size.height / 7 * 3
        let count =  colors.count
        for i in 0..<count {
            let x = CGFloat(i%3) * size.width / 3
            let y = CGFloat(i/3) * size.height / 7 * 4
            let path = UIBezierPath(rect: CGRect(x: x, y: y, width: secHeight, height: secHeight))
            colors[i].setFill()
            path.fill()
            let val: NSString = colors[i].hexValue() as NSString
            val.draw(in: CGRect(x: x+secHeight+4, y: y, width: secWidth-secHeight-4, height: secHeight), withAttributes: [.foregroundColor: UIColor.init(contrastingBlackOrWhiteColorOn: COLOR_CONTENT_BACKGROUND!, isFlat: true)])
            
        }
        
    }

}
