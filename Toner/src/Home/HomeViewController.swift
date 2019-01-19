//
//  ViewController.swift
//  Toner
//
//  Created by LiLi Kazine on 2018/12/6.
//  Copyright © 2018 HNA Group Co.,Ltd. All rights reserved.
//

import UIKit
import Photos

class HomeViewController: BaseTonerViewController {

    
    @IBOutlet weak var analysisItem: UIBarButtonItem!
    @IBOutlet weak var targetImg: UIImageView!
    @IBOutlet weak var imgAuthorLbl: UILabel!
    @IBOutlet weak var importBtn: UIButton! {
        didSet {
            importBtn.layer.cornerRadius = 21
            importBtn.layer.borderWidth = 2
            importBtn.layer.borderColor = COLOR_BROWN?.cgColor
            importBtn.clipsToBounds = true
            importBtn.setTitleColor(COLOR_BROWN, for: .normal)
            importBtn.setTitle("Import", for: .normal)
        }
    }
    
    var picker: UIImagePickerController!
    
    let rotatePresentTransition = RotatePresentTransition()
    
    var bgLayer: CALayer?
    var maskLayer: CAShapeLayer?
    var animationDuration: TimeInterval = 1.2

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if IS_START_UP {
            prepareStartUp()

        }

        picker = UIImagePickerController()
        picker.transitioningDelegate = self
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.navigationBar.titleTextAttributes = [.foregroundColor: MAIN_TINT_DARK,
                                                    .font: UIFont.systemFont(ofSize: 27, weight: .bold)]
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if IS_START_UP {
            animateStartUp()
        }
        
        IS_START_UP = false
    }
    
    @IBAction func itemActions(_ sender: UIBarButtonItem) {
        //only one UIBarButtonItem here
        
    }
    
    @IBAction func btnActions(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
           
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? AnalysisViewController {
            dest.img4Anaylsis = targetImg.image ?? UIImage(named: "ExampleImage")
        }
    }
    
    func prepareStartUp() {
        navigationController?.isNavigationBarHidden = true
        bgLayer = CALayer()
        bgLayer?.frame = view.layer.frame
        bgLayer?.backgroundColor = UIColor(hexString: "FFEEEC")?.cgColor
        bgLayer?.contents = UIImage(named: "toner")?.cgImage
        bgLayer?.contentsGravity = .resizeAspect
        
        view.layer.addSublayer(bgLayer!)
        let maskRect: CGRect = CGRect(x: -(bgLayer!.bounds.height / 4), y: -(bgLayer!.bounds.height / 4), width: bgLayer!.bounds.height * 1.5, height: bgLayer!.bounds.height * 1.5)
        let rectPath = UIBezierPath(rect: maskRect)
        //        let roundPath =
        //            UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: maskRect.origin.x + maskRect.width * 0.5 - 50, y: maskRect.origin.y + maskRect.height * 0.5 - 50), size: CGSize(width: 100, height: 100)))
        //            UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: bgLayer!.position.x - 50, y: bgLayer!.position.y - 50), size: CGSize(width: 100, height: 100)))
        let starPath = UIBezierPath()
        starPath.starPathInRect(rect: CGRect(origin: CGPoint(x: maskRect.origin.x + maskRect.width * 0.5 - 50, y: maskRect.origin.y + maskRect.height * 0.5 - 50), size: CGSize(width: 100, height: 100)))
        
        let bezierPath = UIBezierPath()
        bezierPath.append(rectPath)
        bezierPath.append(starPath)
        
        maskLayer = CAShapeLayer()
        maskLayer?.path = bezierPath.cgPath
        maskLayer?.fillColor = UIColor.white.cgColor
        maskLayer?.fillRule = .evenOdd
        maskLayer?.bounds = maskRect
        maskLayer?.position = bgLayer!.position
        //        maskLayer?.anchorPoint = view.center
        
        bgLayer?.mask = maskLayer
    }
    
    func animateStartUp() {
        let revealAnimation = CAKeyframeAnimation(keyPath: "transform")
        revealAnimation.values = [NSValue(caTransform3D: CATransform3DIdentity), NSValue(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1.0)), NSValue(caTransform3D: CATransform3DIdentity), NSValue(caTransform3D: CATransform3DMakeScale(25, 25, 1.0))]
        revealAnimation.keyTimes = [0.0, 0.2, 0.4, 1.0]
        revealAnimation.timingFunctions = [CAMediaTimingFunction(name: .easeOut), CAMediaTimingFunction(name: .linear), CAMediaTimingFunction(name: .easeIn)]
        
        let spinAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        spinAnimation.values = [0.0, CGFloat.pi/2, CGFloat.pi, -CGFloat.pi/2, 0.0]
        spinAnimation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        spinAnimation.calculationMode = .paced
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [revealAnimation, spinAnimation]
        animationGroup.duration = animationDuration
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
        animationGroup.delegate = self
        
        maskLayer?.add(animationGroup, forKey: "StartUp")
        
        UIView.animate(withDuration: animationDuration * 0.5, delay: animationDuration * 0.5, options: .curveEaseOut, animations: {
            self.navigationController?.isNavigationBarHidden = false
        }, completion: nil)
    }

}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imgAuthorLbl.isHidden = true
//        if let image = info[.editedImage] as? UIImage {
        if let image = info[.originalImage] as? UIImage {
            targetImg.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let startUpAnim = maskLayer?.animation(forKey: "StartUp"), startUpAnim == anim, flag {
            bgLayer = nil
            maskLayer = nil
            IS_START_UP = false
        }

    }
    
}


extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented == picker && source == self {
            rotatePresentTransition.presenting = true
            return rotatePresentTransition
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed == picker {
            rotatePresentTransition.presenting = false
            return rotatePresentTransition
        }
        return nil
    }
    
}
