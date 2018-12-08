//
//  PieChartViewController.swift
//  Toner
//
//  Created by LiLi Kazine on 2018/12/8.
//  Copyright © 2018 HNA Group Co.,Ltd. All rights reserved.
//

import UIKit
import Charts

class PieChartViewController: BaseTonerViewController {

    
    @IBOutlet weak var pieView: PieChartView! {
        willSet {
            newValue.noDataText = ""
        }
    }
    
    var img4Anaylsis: UIImage!
    
    var shrink: UIImage!
    
    var taskDone: (()->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shrink = img4Anaylsis.shrink()
        
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            var ratios: [(color: UIColor, ratio: Double)] = Tools.analyze(image: strongSelf.shrink)
            var per = 0.0
            ratios = ratios.filter{ (color, ratio) in
                if ratio > 0.05 {
                    per += ratio
                }
                return ratio > 0.05
            }


            let dataEntries = ratios.map { (color, ratio) -> PieChartDataEntry in
                let entry = PieChartDataEntry(value: ratio, label: color.hexValue())
                return entry
            }

            let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
            chartDataSet.drawValuesEnabled = true
            chartDataSet.colors = ratios.map{ (color, _ ) in
                return color
            }
            let chartData = PieChartData(dataSet: chartDataSet)
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2
            formatter.multiplier = 100.0
            chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.pieView.drawHoleEnabled = true
                strongSelf.pieView.holeColor = COLOR_CONTENT_BACKGROUND
                strongSelf.pieView.transparentCircleRadiusPercent = 0
                strongSelf.pieView.holeRadiusPercent = 0.3
                strongSelf.pieView.data = chartData
                strongSelf.pieView.rotationEnabled = false
                strongSelf.taskDone()
            }

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
