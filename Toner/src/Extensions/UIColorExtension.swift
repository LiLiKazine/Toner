//
//  UIColorExtension.swift
//  Toner
//
//  Created by 盛立 on 2025/9/2.
//

import UIKit
/*
extension UIColor {
    func hexValue() -> String {
        var currentColor = self
        if cgColor.numberOfComponents < 4 {
            if let components = cgColor.components {
                currentColor = UIColor(red: components[0], green: components[0], blue: components[0], alpha: components[1])
            }
        }
        
        if cgColor.colorSpace?.model != .rgb {
            return "#FFFFFF"
        }
        
        if let components = currentColor.cgColor.components, components.count >= 3 {
            let red = Int(components[0] * 255.0)
            let green = Int(components[1] * 255.0)
            let blue = Int(components[2] * 255.0)
            return String(format: "#%02X%02X%02X", red, green, blue)
        }
        
        return "#FFFFFF"
    }
    
    static func averageColor(from image: UIImage, withAlpha alpha: CGFloat = 1.0) -> UIColor? {
        // Work within the RGB colorspace
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
        
        var rgba: [UInt8] = [0, 0, 0, 0]
        let context = CGContext(
            data: &rgba,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        )
        
        guard let cgContext = context, let cgImage = image.cgImage else { return nil }
        
        // Draw our image down to 1x1 pixels
        cgContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        // Check if image alpha is 0
        if rgba[3] == 0 {
            return UIColor.clear
        } else {
            // Get average
            var averageColor = UIColor(
                red: CGFloat(rgba[0]) / 255.0,
                green: CGFloat(rgba[1]) / 255.0,
                blue: CGFloat(rgba[2]) / 255.0,
                alpha: alpha
            )
            
            // Improve color
            averageColor = averageColor.withMinimumSaturation(0.15)
            
            return averageColor
        }
    }
    
    static func contrastingBlackOrWhite(on backgroundColor: UIColor, isFlat flat: Bool, alpha: CGFloat) -> UIColor {
        var workingBackgroundColor = backgroundColor
        
        // Check if UIColor is a gradient aka a pattern
        if let pattern = backgroundColor.cgColor.pattern {
            // Let's find the average color of the image and contrast against that.
            let size = CGSize(width: 1, height: 1)
            
            // Create a 1x1 bitmap context
            UIGraphicsBeginImageContext(size)
            guard let ctx = UIGraphicsGetCurrentContext() else {
                UIGraphicsEndImageContext()
                return UIColor.clear
            }
            
            // Set the interpolation quality to medium
            ctx.interpolationQuality = .medium
            
            // Draw image scaled down to this 1x1 pixel
            if let gradientImage = backgroundColor.gradientImage {
                gradientImage.draw(in: CGRect(origin: .zero, size: size), blendMode: .copy, alpha: 1.0)
            }
            
            // Read the RGB values from the context's buffer
            if let data = ctx.data?.bindMemory(to: UInt8.self, capacity: 4) {
                workingBackgroundColor = UIColor(
                    red: CGFloat(data[2]) / 255.0,
                    green: CGFloat(data[1]) / 255.0,
                    blue: CGFloat(data[0]) / 255.0,
                    alpha: 1.0
                )
            }
            
            UIGraphicsEndImageContext()
        }
        
        // Calculate Luminance
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha1: CGFloat = 0.0
        
        workingBackgroundColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha1)
        
        // Check if color is transparent
        if alpha1 == 0 {
            return UIColor.clear
        }
        
        // Relative luminance in colorimetric spaces - http://en.wikipedia.org/wiki/Luminance_(relative)
        red *= 0.2126
        green *= 0.7152
        blue *= 0.0722
        let luminance = red + green + blue
        
        if !flat {
            return luminance > 0.6 ? UIColor(red: 0, green: 0, blue: 0, alpha: alpha) : UIColor(red: 1, green: 1, blue: 1, alpha: alpha)
        } else {
            return luminance > 0.6 ?
                UIColor(hue: 0, saturation: 0, brightness: 15.0/100.0, alpha: alpha) :
                UIColor(hue: 192.0/360.0, saturation: 2.0/100.0, brightness: 95.0/100.0, alpha: alpha)
        }
    }
    
    // Helper method to ensure minimum saturation
    func withMinimumSaturation(_ minimumSaturation: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return self
        }
        
        // If current saturation is less than minimum, set it to minimum
        if saturation < minimumSaturation {
            saturation = minimumSaturation
        }
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    // Helper property to get gradient image (this would need to be implemented based on your specific needs)
    private var gradientImage: UIImage? {
        // This is a placeholder - you'll need to implement this based on how gradients are handled in your app
        return nil
    }
}
*/
