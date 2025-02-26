//
//  LSColorUtil.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/1.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//
//  UIColor工具类
//  let color = LSColorUtil.ls_colorWithHexString("#FF0000", alpha: 1.0)
//  let lightColor = LSColorUtil.ls_ligthColor(lightColor: UIColor.white, darkColor: UIColor.black)


import UIKit
import Foundation

enum LSGradientDirectionToColor {
    case horizontal
    case vertical
}

class LSColorUtil {
    static func ls_colorWithHexString(color: String, alpha: CGFloat) -> UIColor {
        var cString: String = color.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if cString.count < 6 {
            return UIColor.clear
        }
        
        // 判断前缀
        if cString.hasPrefix("0X") {
            let index = cString.index(after: cString.startIndex)
            cString = String(cString[index...])
        }
        if cString.hasPrefix("#") {
            let index = cString.index(after: cString.startIndex)
            cString = String(cString[index...])
        }
        if cString.count != 6 {
            return UIColor.clear
        }
        
        // 从六位数值中找到RGB对应的位数并转换
        let rRange = cString.startIndex ..< cString.index(cString.startIndex, offsetBy: 2)
        let rStr = String(cString[rRange])
        
        let gRange = cString.index(cString.startIndex, offsetBy: 2) ..< cString.index(cString.startIndex, offsetBy: 4)
        let gStr = String(cString[gRange])
        
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bStr = String(cString[bIndex...])
        
        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))
    }
    
    //16进制字符串颜色设置
    static func ls_colorWithHexString(color: String) -> UIColor {
        return ls_colorWithHexString(color: color, alpha: 1.0)
    }
    
    //适配暗黑模式
    static func ls_ligthColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkColor
                } else {
                    return lightColor
                }
            }
        }
        return lightColor
    }
    
    //UIColor转16进制
    static func ls_hexFromUIColor(_ color: UIColor) -> String {
        guard let components = color.cgColor.components else {
            return "#FFFFFF"
        }
        
        var adjustedColor = color
        
        if components.count < 4 {
            let red = components[0]
            let green = components[1]
            let blue = components[2]
            let alpha = components[3]
            
            adjustedColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        guard let colorSpaceModel = adjustedColor.cgColor.colorSpace?.model else {
            return "#FFFFFF"
        }
        
        if colorSpaceModel != .rgb {
            return "#FFFFFF"
        }
        
        let red = Int(adjustedColor.cgColor.components?[0] ?? 0.0 * 255.0)
        let green = Int(adjustedColor.cgColor.components?[1] ?? 0.0 * 255.0)
        let blue = Int(adjustedColor.cgColor.components?[2] ?? 0.0 * 255.0)
        
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
    
    //滑动改变渐变色
    static func ls_getRGB(fromColor: String, toColor: String, shade: Float) -> [Float] {
        let fromRgb = ls_getRGB(color: fromColor)
        let toRgb = ls_getRGB(color: toColor)
        
        let fromR = fromRgb[0]
        let fromG = fromRgb[1]
        let fromB = fromRgb[2]
        
        let toR = toRgb[0]
        let toG = toRgb[1]
        let toB = toRgb[2]
        
        let diffR = toR - fromR
        let diffG = toG - fromG
        let diffB = toB - fromB
        
        let red = fromR + (diffR * shade)
        let green = fromG + (diffG * shade)
        let blue = fromB + (diffB * shade)
        
        return [red / 255.0, green / 255.0, blue / 255.0]
    }
    
    static func ls_getRGB(color: String) -> [Float] {
        let rRange = color.startIndex..<color.index(color.startIndex, offsetBy: 2)
        let rString = String(color[rRange])
        
        let gRange = color.index(color.startIndex, offsetBy: 2)..<color.index(color.startIndex, offsetBy: 4)
        let gString = String(color[gRange])
        
        let bRange = color.index(color.startIndex, offsetBy: 4)..<color.endIndex
        let bString = String(color[bRange])
        
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return [Float(r) / 255.0, Float(g) / 255.0, Float(b) / 255.0]
    }
    
    //设置渐变色
    static func ls_gradientColor(colors: [UIColor], direction: LSGradientDirectionToColor) -> UIColor {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        
        switch direction {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        
        gradientLayer.frame = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIColor()
        }
        
        gradientLayer.render(in: context)
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return UIColor()
        }
        
        UIGraphicsEndImageContext()
        return UIColor(patternImage: gradientImage)
    }
}
