//
//  LSImageUtil.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/1.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//
//

import UIKit
import Foundation

class LSImageUtil {
    //通过颜色生成一张图片
    static func ls_colorToImage(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.setFillColor(color.cgColor)
            ctx.fill(rect)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        }
        
        return nil
    }
    
    //通过颜色改变图片颜色
    static func ls_changeImage(_ image: UIImage, toColor tintColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        
        if let ctx = UIGraphicsGetCurrentContext() {
            tintColor.setFill()
            let bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            UIRectFill(bounds)
            
            image.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
            
            let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return tintedImage
        }
        
        return nil
    }
}
