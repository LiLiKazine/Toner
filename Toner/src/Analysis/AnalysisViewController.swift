//
//  AnalysisViewController.swift
//  Toner
//
//  Created by LiLi Kazine on 2018/12/7.
//  Copyright © 2018 HNA Group Co.,Ltd. All rights reserved.
//

import UIKit
import ChameleonFramework
import SnapKit
import Photos
import SkeletonView

class AnalysisViewController: BaseTonerViewController {

    @IBOutlet weak var saveItem: UIBarButtonItem! {
        didSet{
            saveItem.tintColor = MAIN_TINT
        }
    }
    @IBOutlet weak var colorStack: UIStackView!
    @IBOutlet weak var colorValueStack: UIStackView!
    @IBOutlet weak var avgColorView: UIView!
    @IBOutlet weak var avgColorValueLbl: UILabel!
    @IBOutlet weak var targetImgView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var img4Anaylsis: UIImage!
    
    var shrink: UIImage!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.showAnimatedGradientSkeleton()
        let gradient = SkeletonGradient(baseColor: MAIN_TINT_DARK)
        colorStack.showAnimatedGradientSkeleton(usingGradient: gradient, animation: nil)
        colorValueStack.showAnimatedGradientSkeleton(usingGradient: gradient, animation: nil)
        
        let imgWidth = img4Anaylsis.size.width

        print(imgWidth)
        shrink = img4Anaylsis.shrink(target: imgWidth > 800.0 ? 800.0 : imgWidth)
        
        targetImgView.image = img4Anaylsis

        
        setStack()
        
        setAvg()
        
        
    }
    @IBAction func itemAction(_ sender: UIBarButtonItem) {
        
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, false, 0.0)

        let savedContentOffset = scrollView.contentOffset
        let savedFrame = scrollView.frame

        scrollView.contentOffset = CGPoint.zero
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)

        scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()

        scrollView.contentOffset = savedContentOffset
        scrollView.frame = savedFrame

        UIGraphicsEndImageContext()
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
    
    private func showSaveAlbumAlert(isSuccess: Bool, err: Error?) {
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
            let avg = AverageColorFromImage(strongSelf.shrink)
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.avgColorView.backgroundColor = avg
                strongSelf.avgColorValueLbl.text = avg.hexValue()
            }
            
        }
        
    }
    
    private func setStack() {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            
//            var colors = ColorsFromImage(strongSelf.shrink, withFlatScheme: true)
            var colors = Tools.analyzeWithKMeans(image: strongSelf.img4Anaylsis, count: 5).map{$0.color}
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
                
                strongSelf.colorStack.hideSkeleton()
                strongSelf.colorValueStack.hideSkeleton()
                
                colors.forEach{ color in
                    let patch = UIView()
                    patch.backgroundColor = color
                    strongSelf.colorStack.addArrangedSubview(patch)
                    patch.snp.makeConstraints{make in
                        let width = Int(strongSelf.colorStack.bounds.width) / colors.count
                        let height = strongSelf.colorStack.bounds.height
                        make.width.equalTo(width)
                        make.height.equalTo(height)
                    }
                    let val = UILabel()
                    val.textAlignment = .center
                    val.textColor = COLOR_BROWN
                    val.text = color.hexValue()
                    val.font = UIFont.systemFont(ofSize: SIZE_ANNOTATION)
                    strongSelf.colorValueStack.addArrangedSubview(val)
                    val.snp.makeConstraints{ make in
                        let width = Int(strongSelf.colorValueStack.bounds.width) / colors.count
                        let height = strongSelf.colorValueStack.bounds.height
                        make.width.equalTo(width)
                        make.height.equalTo(height)
                    }
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
