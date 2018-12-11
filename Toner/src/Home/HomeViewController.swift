//
//  ViewController.swift
//  Toner
//
//  Created by LiLi Kazine on 2018/12/6.
//  Copyright © 2018 HNA Group Co.,Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
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
    
    private var picker: UIImagePickerController!
    private var loading: NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.navigationBar.titleTextAttributes = [.foregroundColor: MAIN_TINT_DARK,
                                                    .font: UIFont.systemFont(ofSize: 27, weight: .bold)]
       
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

