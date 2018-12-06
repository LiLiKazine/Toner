//
//  MainNavigationController.swift
//  Toner
//
//  Created by LiLi Kazine on 2018/12/6.
//  Copyright © 2018 HNA Group Co.,Ltd. All rights reserved.
//

import UIKit

class MainNavigationController: BaseTonerNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.titleTextAttributes = [.foregroundColor: MAIN_TINT_DARK,
                                             .font: UIFont.systemFont(ofSize: 27, weight: .bold)]
        UINavigationBar.appearance().barTintColor = BAR_BACKGROUND
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
