
//
//  Tools.swift
//  Toner
//
//  Created by LiLi Kazine on 2018/12/7.
//  Copyright © 2018 HNA Group Co.,Ltd. All rights reserved.
//

import UIKit

class Tools: NSObject {
    static func analyze(image: UIImage) -> [(color: UIColor, ratio: Double)] {
        var ratios = [(color: UIColor, ratio: Double)]()
        guard let provider = image.cgImage?.dataProvider, let pxData = provider.data, let cfData = CFDataGetBytePtr(pxData) else {
            return ratios
        }
        let dataLength = CFDataGetLength(pxData)
        let channelNum = 4 //RGBA
        var colors = [String: Double]() //kye: R-G-B val: num
        var colorCount: Double = 0
        var idx = 0
        while idx < dataLength {
            idx += channelNum
            if cfData[idx+3] != 0 {
                // not transparent
                colorCount += 1
                let red = cfData[idx]
                let green = cfData[idx+1]
                let blue = cfData[idx+2]
                let key = "\(red)-\(green)-\(blue)"
                if !colors.keys.contains(key) {
                    colors[key] = 1
                } else {
                    colors[key] = colors[key]! + 1.0
                }
            }
        }
//        let colorVal = colors.values.sorted{ $0 > $1 }
        for key in colors.keys {
            let rgb = key.split(separator: "-")
            let r = CGFloat(truncating: NumberFormatter().number(from: String(rgb[0]))!)
            let g = CGFloat(truncating: NumberFormatter().number(from: String(rgb[1]))!)
            let b = CGFloat(truncating: NumberFormatter().number(from: String(rgb[2]))!)
            let color = UIColor(red: r, green: g, blue: b, alpha: 1)
            let rate = colors[key]! / colorCount
            let ratio = (color, rate)
            ratios.append(ratio)
        }
        return ratios
    }
}
