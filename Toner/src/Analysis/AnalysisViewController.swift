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

class AnalysisViewController: BaseTonerViewController {

    @IBOutlet weak var saveItem: UIBarButtonItem! {
        didSet{
            saveItem.tintColor = MAIN_TINT
        }
    }
    @IBOutlet weak var colorStack: UIStackView!
    @IBOutlet weak var avgColorView: UIView!
    
    var img4Anaylsis: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let colors = ColorsFromImage(img4Anaylsis, withFlatScheme: true)
        colors.forEach{ color in
            let patch = UIView()
            patch.backgroundColor = color
            colorStack.addArrangedSubview(patch)
            patch.snp.makeConstraints{make in
                let width = Int(colorStack.bounds.width) / colors.count
                let height = colorStack.bounds.height
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
        }
        print(colors)
        let avg = AverageColorFromImage(img4Anaylsis)
        avgColorView.backgroundColor = avg
        let ratios: [(color: UIColor, ratio: Double)] = Tools.analyze(image: img4Anaylsis)
        print(ratios)
    }
    
    
    deinit {
        for view in colorStack.subviews {
            view.removeFromSuperview()
        }
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
