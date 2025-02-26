//
//  UITabBar+LSBadge.swift
//  GenericProjectForSwift
//
//  Created by 漠然丶情到深处 on 2019/12/22.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import Foundation
import UIKit

extension UITabBar {
    func showBadgeOnItemIndex(index: Int) {
        //移除之前的小红点
        self.removeBadgeOnItemIndex(index: index)
        //新建小红点
        let badgeView = UIView.init()
        badgeView.tag = 88 + index
        badgeView.layer.cornerRadius = 5
        badgeView.backgroundColor = LSRedColor
        let tabFrame: CGRect = self.frame
        
        let dele = (UIApplication.shared.delegate) as! AppDelegate
        let tabbarItemNums: Int = dele.mainTabBar.viewControllers!.count
        
        
        //确定小红点的位置
        let percentX: CGFloat = (CGFloat(index) + 0.6) / CGFloat(tabbarItemNums)
        let x: CGFloat = CGFloat(ceilf(Float(CGFloat(percentX * tabFrame.size.width))))
        let y: CGFloat = CGFloat(ceilf(Float(0.1 * tabFrame.size.height)))
        badgeView.frame = CGRect(x: x, y: y, width: 10, height: 10)
        self.addSubview(badgeView)
    }
    
    func hideBadgeOnItemIndex(index: Int) {
        //移除小红点
        self.removeBadgeOnItemIndex(index: index)
    }
    
    func removeBadgeOnItemIndex(index: Int) {
        //按照tag值进行移除
        for subView in self.subviews {
            if superview?.tag == 88 + index {
                subView.removeFromSuperview()
            }
        }
    }
}
