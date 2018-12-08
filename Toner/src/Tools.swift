
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
        let sorted = assort(colors: Array(colors.keys), threshold: 0)
        ratios = merge(sorted: sorted, data: colors, colorCount: colorCount)
        return ratios
    }
    
    static func dec2hex(dec: Int) -> String {
        return String(dec, radix: 16)
    }
    
    static func assort(colors: [String], threshold: Int) -> [String: [String]] {
        var sorted = [String: [String]]()
        // divide rgb space into 15*15*15 chunks
        for color in colors {
            let rgb = color.split(separator: "-")
            let r = Int(rgb[0])!
            let g = Int(rgb[1])!
            let b = Int(rgb[2])!
            let key = "\(r/51)\(g/51)\(b/51)"
            if sorted.keys.contains(key) {
                sorted[key]!.append(color)
            } else {
                sorted[key] = [color]
            }
        }
        return sorted
    }
    
    static func merge(sorted: [String: [String]], data: [String: Double], colorCount: Double) -> [(color: UIColor, ratio: Double)] {
        var ratios = [(color: UIColor, ratio: Double)]()
        for group in sorted {
            let rgbGroup = group.value
            var ratioGroup = [Double]()
            for rgb in rgbGroup {
                let ratio = data[rgb]! / colorCount
                ratioGroup.append(ratio)
            }
            let total = ratioGroup.reduce(0, { $0 + $1 })
            var avgR = 0.0
            var avgG = 0.0
            var avgB = 0.0
            for i in 0 ..< ratioGroup.count {
                let weight = ratioGroup[i] / total
                let rgb = rgbGroup[i].split(separator: "-")
                let r = Double(rgb[0])!
                let g = Double(rgb[1])!
                let b = Double(rgb[2])!
                avgR += r * weight
                avgG += g * weight
                avgB += b * weight
            }
//            for i in 0 ..< ratioGroup.count {
//                let count = Double(ratioGroup.count)
//                let rgb = rgbGroup[i].split(separator: "-")
//                let r = Double(rgb[0])!
//                let g = Double(rgb[1])!
//                let b = Double(rgb[2])!
//                avgR += r / count
//                avgG += g / count
//                avgB += b / count
//            }
            let tuple = (UIColor(red: CGFloat(avgR / 255.0), green: CGFloat(avgG / 255.0), blue: CGFloat(avgB / 255.0), alpha: 1), total)
            ratios.append(tuple)
        }
        return ratios
    }
}
