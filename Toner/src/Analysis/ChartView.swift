//
//  ChartView.swift
//  Toner
//
//  Created by LiLi Kazine on 2019/1/23.
//

import UIKit
import ChameleonFramework

class ChartView: UIView {
    
    let contents: [(color: UIColor, ratio: Double)]
    let hollowRatio: Double
    
    init(frame: CGRect, hollowRatio: Double, contents: [(color: UIColor, ratio: Double)]) {
        self.contents = contents
        self.hollowRatio = hollowRatio
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
//        COLOR_CONTENT_BACKGROUND?.setFill()
//        UIRectFill(rect)
        
        let origin = rect.origin
        let size = rect.size
        let radius: CGFloat = min(size.width, size.height)/2
        let center = CGPoint(x: origin.x+size.width/2, y: origin.y+size.height/2)
        var startAngle: CGFloat = CGFloat(drand48()) * 2 * .pi
        var temp: [(startAngle: CGFloat, endAngle: CGFloat, color: UIColor, ratio: Double)] = []
        for content in contents {
            let angle: CGFloat = CGFloat(content.ratio) * 2 * .pi
            let endAngle = startAngle + angle
            let path = UIBezierPath()
            path.move(to: getPoint(radius: radius * CGFloat(hollowRatio), angle: startAngle, offset: center))
            path.addLine(to: getPoint(radius: radius, angle: startAngle, offset: center))
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addLine(to: getPoint(radius: radius * CGFloat(hollowRatio), angle: endAngle, offset: center))
            path.addArc(withCenter: center, radius: radius * CGFloat(hollowRatio), startAngle: endAngle, endAngle: startAngle, clockwise: false)
            path.close()
            content.color.setFill()
            path.fill()
            temp.append((startAngle, endAngle, content.color, content.ratio))
            startAngle = endAngle
        }
        for data in temp {
            let startAngle = data.startAngle
            let endAngle = data.endAngle
            let color = data.color
            let angle = (startAngle+endAngle)/2
            let less = angle.truncatingRemainder(dividingBy: (2 * .pi))
            let percent = 1 - (abs(.pi - less) / (.pi * 1.7))
//            print(percent)

            let val: NSString = NSString(format: "%.2f%%", data.ratio*100)
            let point = getPoint(radius: radius * percent, angle: angle, offset: center)
//            print(point)
            val.draw(at: point, withAttributes: [.foregroundColor: UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true), .font: UIFont.systemFont(ofSize: 12)])
        }
        
    }
    
    func getPoint(radius: CGFloat, angle: CGFloat, offset: CGPoint) -> CGPoint {
        return CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y)
    }

}
