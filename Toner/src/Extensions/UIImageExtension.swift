//
//  UIImageExtension.swift
//  Toner
//
//  Created by LiLi Kazine on 2018/12/8.
//  Copyright © 2018 HNA Group Co.,Ltd. All rights reserved.
//

import UIKit

extension UIImage {
    func shrink(target: CGFloat) -> UIImage {
        guard let image = self.copy() as? UIImage else {
            return self
        }
        let size = image.size
        if size.width < target {
            return image
        }
        
        let widthRatio  = target  / size.width
        let heightRatio = widthRatio * size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
