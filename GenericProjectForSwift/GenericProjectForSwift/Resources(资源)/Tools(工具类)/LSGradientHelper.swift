//
//  LSGradientHelper.swift
//  GenericProjectForSwift
//
//  Created by 漠然丶情到深处 on 2023/5/26.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//
//  设置渐变色
//  LSGradientHelper.ls_setGradientBackground(view: bgView, colors: [UIColor.ls_colorWithHexString(color: "F1F5F8", alpha: 1), UIColor.ls_colorWithHexString(color: "F1F5F8", alpha: 0)], direction: LSGradientDirection.vertical)


import UIKit

enum LSGradientDirection {
    case horizontal
    case vertical
}

class LSGradientHelper {
    static func ls_setGradientBackground(view: UIView, colors: [UIColor], direction: LSGradientDirection) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        switch direction {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        
        var cgColors: [CGColor] = []
        for color in colors {
            cgColors.append(color.cgColor)
        }
        
        gradientLayer.colors = cgColors
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
