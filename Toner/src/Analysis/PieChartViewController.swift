//
//  PieChartViewController.swift
//  Toner
//
//  Created by LiLi Kazine on 2018/12/8.
//  Copyright © 2018 HNA Group Co.,Ltd. All rights reserved.
//

import UIKit

class PieChartViewController: BaseTonerViewController {

    
    @IBOutlet weak var pieView: UIView!
    
    var img4Anaylsis: UIImage!
    
    var shrink: UIImage!
    
    var taskDone: (()->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        let imgWidth = img4Anaylsis.size.width
        shrink = img4Anaylsis.shrink(target: imgWidth > 800.0 ? 800.0 : imgWidth)
        
        let loading = UILabel(frame: pieView.bounds)
        loading.textAlignment = .center
        loading.text = "loading..."
        loading.font = UIFont.systemFont(ofSize: 12.0)
        loading.textColor = COLOR_BROWN
        loading.backgroundColor = .clear
        loading.layer.opacity = 0.2
        pieView.addSubview(loading)
        
        let twinkle = CABasicAnimation(keyPath: "opacity")
        twinkle.fromValue = 0.2
        twinkle.toValue = 1.0
        twinkle.duration = 0.5
        twinkle.repeatCount = .infinity
        twinkle.autoreverses = true
        // in case animation stops when go into background mode
        twinkle.isRemovedOnCompletion = false
        loading.layer.add(twinkle, forKey: nil)
        
        
        let radius = min(pieView.bounds.width, pieView.bounds.height)
        
        let ovalLayer = CAShapeLayer()
        ovalLayer.frame = pieView.bounds
        ovalLayer.fillColor = UIColor.clear.cgColor
        ovalLayer.strokeColor = COLOR_BROWN?.cgColor
        ovalLayer.lineWidth = radius * 0.4
        let ovalPath = UIBezierPath.init(ovalIn: pieView.bounds)
        ovalLayer.path = ovalPath.cgPath
        pieView.layer.addSublayer(ovalLayer)
        ovalLayer.transform = CATransform3DMakeScale(1.0/1.4, 1.0/1.4, 0.0)

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -0.5
        strokeStartAnimation.toValue = 1.0
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1.5
        strokeAnimationGroup.repeatCount = .infinity
        // in case animation stops when go into background mode
        strokeAnimationGroup.isRemovedOnCompletion = false
        strokeAnimationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        
        ovalLayer.add(strokeAnimationGroup, forKey: nil)
        
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            let ratios: [(color: UIColor, ratio: Double)] = Tools.analyzeWithKMeans(image: strongSelf.shrink, count: 5)
            
           
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                
                let endStrokerHead = CABasicAnimation(keyPath: "strokeStart")
                endStrokerHead.toValue = 0
                let endStrokeTail = CABasicAnimation(keyPath: "strokeEnd")
                endStrokeTail.toValue = 0
                let endStrokeGroup = CAAnimationGroup()
                endStrokeGroup.setValue("stroke", forKey: "id")
                endStrokeGroup.setValue(ovalLayer, forKey: "layer")
                endStrokeGroup.delegate = self
                endStrokeGroup.animations = [endStrokerHead, endStrokeTail]
                endStrokeGroup.duration = 0.4
                endStrokeGroup.fillMode = .forwards
                endStrokeGroup.isRemovedOnCompletion = false
                ovalLayer.add(endStrokeGroup, forKey: nil)
                
                let endTwinkle = CABasicAnimation(keyPath: "opacity")
                endTwinkle.setValue("twinkle", forKey: "id")
                endTwinkle.setValue(loading, forKey: "view")
                endTwinkle.delegate = self
                endTwinkle.toValue = 0
                endTwinkle.duration = 0.4
                endTwinkle.fillMode = .forwards
                endTwinkle.isRemovedOnCompletion = false
                loading.layer.add(endTwinkle, forKey: nil)
               
                let chart = ChartView(frame: strongSelf.pieView.bounds, hollowRatio: 0.33, contents: ratios)

                let maskLayer = CAShapeLayer()
                maskLayer.frame = chart.bounds
                maskLayer.fillColor = UIColor.clear.cgColor
                maskLayer.strokeColor = UIColor.white.cgColor
                maskLayer.strokeStart = 0
                maskLayer.strokeEnd = 0
                maskLayer.lineWidth = radius/2
                let circlePath = UIBezierPath(ovalIn: CGRect(x: radius/4, y: radius/4, width: radius/2, height: radius/2))
                maskLayer.path = circlePath.cgPath
                chart.layer.mask = maskLayer

                let drawChartAnim = CABasicAnimation(keyPath: "strokeEnd")
                drawChartAnim.fromValue = 0
                drawChartAnim.toValue = 1.0
                drawChartAnim.duration = 0.7
                drawChartAnim.beginTime = CACurrentMediaTime() + 0.5
                drawChartAnim.isRemovedOnCompletion = false
                drawChartAnim.fillMode = .forwards
                maskLayer.add(drawChartAnim, forKey: nil)
                
                strongSelf.pieView.addSubview(chart)
                
//                strongSelf.taskDone()
            }

        }
    }

    func pauseAnim(in layer: CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0
        layer.timeOffset = pausedTime
        
    }
    
    func resumeAnim(in layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PieChartViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let id = anim.value(forKey: "id") as? String, id == "stroke" , let layer = anim.value(forKey: "layer") as? CALayer {
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
        if let id = anim.value(forKey: "id") as? String, id == "twinkle", let view = anim.value(forKey: "view") as? UIView {
            view.layer.removeAllAnimations()
            view.removeFromSuperview()
        }
    }
    
}
