//
//  ViewController.swift
//  Toner
//
//  Created by LiLi Kazine on 2018/12/6.
//  Copyright © 2018 HNA Group Co.,Ltd. All rights reserved.
//

import UIKit

class MainViewController: BaseTonerViewController {

    
    @IBOutlet weak var analysisItem: UIBarButtonItem! {
        didSet {
            analysisItem.tintColor = MAIN_TINT
        }
    }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func itemActions(_ sender: UIBarButtonItem) {
        //only one UIBarButtonItem here
        
    }
    
    @IBAction func btnActions(_ sender: UIButton) {
    }
    

}

