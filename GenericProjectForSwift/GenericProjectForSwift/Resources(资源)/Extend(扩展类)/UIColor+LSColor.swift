//
//  UIColor+LSColor.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/12/27.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func colorWithHexString(color: String,alpha: CGFloat) -> UIColor {
        var cString: String = color.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if cString.count < 6 {
            return UIColor.clear
        }

        //判断前缀
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
        
        //从六位数值中找到RGB对应的位数并转换
        let rRange = cString.startIndex ..< cString.index(cString.startIndex, offsetBy: 2)
        let rStr = String(cString[rRange])
        
        let gRange = cString.index(cString.startIndex, offsetBy: 2) ..< cString.index(cString.startIndex, offsetBy: 4)
        let gStr = String(cString[gRange])
        
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bStr = String(cString[bIndex...])
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))
    }
    
    func colorWithHexString(color: String) -> UIColor {
        return colorWithHexString(color: color, alpha: 1.0)
    }
}
