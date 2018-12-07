//
//  AnalysisViewController.swift
//  Toner
//
//  Created by LiLi Kazine on 2018/12/7.
//  Copyright © 2018 HNA Group Co.,Ltd. All rights reserved.
//

import UIKit

class AnalysisViewController: BaseTonerViewController {

    @IBOutlet weak var saveItem: UIBarButtonItem! {
        didSet{
            saveItem.tintColor = MAIN_TINT
        }
    }
    
    var img4Anaylsis: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
