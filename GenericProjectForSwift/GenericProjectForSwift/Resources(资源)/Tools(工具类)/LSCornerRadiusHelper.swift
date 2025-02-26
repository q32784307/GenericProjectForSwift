//
//  LSCornerRadiusHelper.swift
//  GenericProjectForSwift
//
//  Created by 漠然丶情到深处 on 2023/5/26.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//
//  设置圆角，可设置部分圆角
//  LSCornerRadiusHelper.ls_setCornerRadius(for: mainTableView, with: 4, topLeft: true, topRight: true, bottomLeft: true, bottomRight: true)
//  LSCornerRadiusHelper.setCornerRadius(for: myView, topLeftRadius: 20, topRightRadius: 10, bottomLeftRadius: nil, bottomRightRadius: 30)

import UIKit

class LSCornerRadiusHelper {
    //设置圆角统一半径
    static func ls_setCornerRadius(for view: UIView, with radius: CGFloat, topLeft: Bool = true, topRight: Bool = true, bottomLeft: Bool = true, bottomRight: Bool = true) {
        var corners: CACornerMask = []
        
        if topLeft {
            corners.insert(.layerMinXMinYCorner)
        }
        
        if topRight {
            corners.insert(.layerMaxXMinYCorner)
        }
        
        if bottomLeft {
            corners.insert(.layerMinXMaxYCorner)
        }
        
        if bottomRight {
            corners.insert(.layerMaxXMaxYCorner)
        }
        
        view.layer.cornerRadius = radius
        view.layer.maskedCorners = corners
        view.layer.masksToBounds = true
    }
    
    //分别设置圆角半径
    static func ls_setCornerRadius(for view: UIView, topLeftRadius: CGFloat? = nil, topRightRadius: CGFloat? = nil, bottomLeftRadius: CGFloat? = nil, bottomRightRadius: CGFloat? = nil) {
            var corners: CACornerMask = []
            
            if let radius = topLeftRadius {
                corners.insert(.layerMinXMinYCorner)
                view.layer.cornerRadius = radius
            }
            
            if let radius = topRightRadius {
                corners.insert(.layerMaxXMinYCorner)
                view.layer.cornerRadius = radius
            }
            
            if let radius = bottomLeftRadius {
                corners.insert(.layerMinXMaxYCorner)
                view.layer.cornerRadius = radius
            }
            
            if let radius = bottomRightRadius {
                corners.insert(.layerMaxXMaxYCorner)
                view.layer.cornerRadius = radius
            }
            
            view.layer.maskedCorners = corners
            view.layer.masksToBounds = true
        }
}
