//
//  AnalysisViewController.swift
//  Toner
//
//  Created by LiLi Kazine on 2018/12/7.
//  Copyright © 2018 HNA Group Co.,Ltd. All rights reserved.
//

import UIKit
import ChameleonFramework
import Photos

class AnalysisViewController: BaseTonerViewController {

    @IBOutlet weak var saveItem: UIBarButtonItem! {
        didSet{
            saveItem.tintColor = MAIN_TINT
        }
    }
    @IBOutlet weak var colorStackContainerView: UIView! {
        didSet {
            colorStackContainerView.layer.cornerRadius = 8.0
            colorStackContainerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var colorStackContainerMiddleView: UIView!
    @IBOutlet weak var colorValueContainerView: UIView!
    @IBOutlet weak var colorStack: UIStackView!
    @IBOutlet weak var colorValueStack: UIStackView!
    @IBOutlet weak var avgColorView: UIView! {
        didSet {
            avgColorView.layer.cornerRadius = 24
            avgColorView.clipsToBounds = true
        }
    }
    @IBOutlet weak var avgColorValueLbl: UILabel!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var targetImgView: UIImageView! {
        didSet {
            targetImgView.layer.cornerRadius = 15
            targetImgView.clipsToBounds = true
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    var img4Anaylsis: UIImage!
    
    var shrink: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imgWidth = img4Anaylsis.size.width
        let ratio = img4Anaylsis.size.height / imgWidth
        imgHeightConstraint.constant = targetImgView.bounds.width * ratio

//        print(imgWidth)
        shrink = img4Anaylsis.shrink(target: imgWidth > 800.0 ? 800.0 : imgWidth)
        
        targetImgView.image = img4Anaylsis

        setStack()
        
        setAvg()
        
    }
    
    func screenShot() {
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, false, 0.0)
        
        let savedSize = scrollView.frame.size
        scrollView.frame.size = scrollView.contentSize
        
        scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        scrollView.frame.size = savedSize
        UIView.animate(withDuration: 0.4) {
            self.scrollView.contentOffset = CGPoint.zero
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image!)
        }) { (isSuccess: Bool, error: Error?) in
            DispatchQueue.main.async { [weak self] in
                self?.showSaveAlbumAlert(isSuccess: isSuccess, err: error)
            }
            if !isSuccess {
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func itemAction(_ sender: UIBarButtonItem) {
        // Save screen shot

        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView.contentOffset = CGPoint.zero
        }) { _ in
            self.screenShot()
        }
        
    }
    
    private func showSaveAlbumAlert(isSuccess: Bool, err: Error?) {
        // Request authorization
        let title = isSuccess ? "Succeeded" : "Failed"
        let tip = isSuccess ? "Successfully Saved Photo to Album." : err?.localizedDescription
        let alertController = UIAlertController(title: title,
        message: tip, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
        action in
        print("OK")
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    private func setAvg() {
        
        
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            let avg = UIColor(averageColorFrom: strongSelf.shrink)
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.avgColorView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                strongSelf.avgColorView.backgroundColor = avg
                strongSelf.avgColorValueLbl.text = avg?.hexValue()
                UIView.animate(withDuration: 0.7, animations: {
                    strongSelf.avgColorView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }
            
        }
        
    }
    

    private func setStack() {
        

        //Scaling loading animation
        let replicator = CAReplicatorLayer()

        let line = CALayer()
        replicator.frame = colorStackContainerView.bounds
        replicator.masksToBounds = true
        colorStackContainerView.layer.addSublayer(replicator)
        
        line.frame = CGRect(x: 0, y: colorStackContainerView.bounds.height/2-4.0, width: 8.0, height: 8.0)
        line.backgroundColor = COLOR_BROWN!.cgColor
        line.cornerRadius = 2
        line.opacity = 0.2
        
        replicator.addSublayer(line)
        // Should be 10 = 8width + 2offset, set to 9 to produce a bit more lines, to fill the view.
        replicator.instanceCount = Int(colorStackContainerView.bounds.width / 9)
        replicator.instanceTransform = CATransform3DMakeTranslation(10, 0, 0)
        replicator.instanceDelay = 0.02
        
        let scale = CABasicAnimation(keyPath: "transform")
        scale.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scale.toValue = NSValue(caTransform3D: CATransform3DMakeScale(0.7, 8, 1.0))
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0.4
        opacity.toValue = 1.0
        

        let group = CAAnimationGroup()
        group.animations = [scale, opacity]
        group.duration = 0.4
        group.repeatCount = .infinity
        group.autoreverses = true
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        // in case animation stops when go into background mode
        group.isRemovedOnCompletion = false
        line.add(group, forKey: "line")
        // -- animation
        
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            
//            var colors = ColorsFromImage(strongSelf.shrink, withFlatScheme: true)
            var colors = Tools.analyzeWithKMeans(image: strongSelf.shrink, count: 5).map{$0.color}
            var record = [UIColor: Int]()
            var dups = [Int]()
            for i in 0 ..< colors.count {
                let color = colors[i]
                if record.keys.contains(color) {
                    dups.append(i)
                } else {
                    record[color] = 1
                }
            }
            dups.reverse()
            dups.forEach{ idx in
                colors.remove(at: idx)
            }
        
            DispatchQueue.main.async {  [weak self] in
                guard let strongSelf = self else { return }
                
                // Hide Colors
                let colorMaskLayer = CAShapeLayer()
                let colorMaskPath = UIBezierPath(rect: CGRect(x: 0, y: strongSelf.colorStackContainerMiddleView.bounds.height/2-1, width: strongSelf.colorStackContainerMiddleView.bounds.width, height: 0))
                colorMaskLayer.path = colorMaskPath.cgPath
                colorMaskLayer.fillColor = UIColor.white.cgColor
                strongSelf.colorStackContainerMiddleView.layer.mask = colorMaskLayer
                // Animate out Colors
                let newPath = UIBezierPath(rect: strongSelf.colorStackContainerMiddleView.bounds)
                let expand = CABasicAnimation(keyPath: "path")
                expand.toValue = newPath.cgPath
                expand.duration = 0.4
                expand.fillMode = .forwards
                expand.isRemovedOnCompletion = false
                expand.beginTime = CACurrentMediaTime() + 0.4
                expand.delegate = self
                expand.setValue("expand", forKey: "id")
                colorMaskLayer.add(expand, forKey: nil)
                // Stop scaling loading animation
                let cease = CABasicAnimation(keyPath: "transform")
                cease.delegate = self
                cease.toValue = NSValue(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 1.0))
                cease.duration = 0.4
                cease.isRemovedOnCompletion = false
                cease.fillMode = .forwards
                cease.setValue("cease", forKey: "id")
                cease.setValue(replicator, forKey: "layer")
                line.add(cease, forKey: "cease")
                
                // Bring out color hex value
                strongSelf.colorValueContainerView.alpha = 0.0
                UIView.animate(withDuration: 0.8, animations: {
                    self?.colorValueContainerView.alpha = 1.0
                })

                for (idx, color) in colors.enumerated() {

                    let patch = strongSelf.colorStack.viewWithTag(idx+1)
                    let val = strongSelf.colorValueStack.viewWithTag(idx+1) as! UILabel
                    patch?.backgroundColor = color
                    val.text = color.hexValue()

                }
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    deinit {
        for view in colorStack.subviews {
            view.removeFromSuperview()
        }
        for view in colorValueStack.subviews {
            view.removeFromSuperview()
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PieChartViewController {
            dest.img4Anaylsis = img4Anaylsis
//            dest.taskDone = { [weak self] in
//            }
        }
    }

}

fileprivate extension UIScrollView {
    func screenshot()->UIImage{
        var image = UIImage();
        
        UIGraphicsBeginImageContextWithOptions(self.contentSize, false, UIScreen.main.scale)
        
        // save initial values
        let savedContentOffset = self.contentOffset;
        let savedFrame = self.frame;
        let savedBackgroundColor = self.backgroundColor
        
        // reset offset to top left point
        self.contentOffset = CGPoint.zero;
        // set frame to content size
        self.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height);
        // remove background
//        self.backgroundColor = UIColor.clear
        
        // make temp view with scroll view content size
        // a workaround for issue when image on ipad was drawn incorrectly
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height))
        
        // save superview
        let tempSuperView = self.superview
        // remove scrollView from old superview
        self.removeFromSuperview()
        // and add to tempView
        tempView.addSubview(self)
        
        // render view
        // drawViewHierarchyInRect not working correctly
        tempView.layer.render(in: UIGraphicsGetCurrentContext()!)
        // and get image
        image = UIGraphicsGetImageFromCurrentImageContext()!;
        
        // and return everything back
        tempView.subviews[0].removeFromSuperview()
        tempSuperView?.addSubview(self)
        
        // restore saved settings
        self.contentOffset = savedContentOffset;
        self.frame = savedFrame;
        self.backgroundColor = savedBackgroundColor
        
        UIGraphicsEndImageContext();
        
        return image
    }
}

extension AnalysisViewController: CAAnimationDelegate {
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let id = anim.value(forKey: "id") as? String, id == "cease", let layer = anim.value(forKey: "layer") as? CALayer {
                layer.removeAllAnimations()
                layer.removeFromSuperlayer()
        }
        
        if let id = anim.value(forKey: "id") as? String, id == "expand" {
            colorStackContainerView.layer.mask = nil
            colorStackContainerMiddleView.layer.mask = nil
        }
        
    }
    
}
