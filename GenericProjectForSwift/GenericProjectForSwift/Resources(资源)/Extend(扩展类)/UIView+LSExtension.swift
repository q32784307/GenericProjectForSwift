//
//  UIView+LSExtension.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/12/24.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(x) {
            var frame = self.frame
            frame.origin.x = x
            self.frame = frame
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(y) {
            var frame = self.frame
            frame.origin.y = y
            self.frame = frame
        }
    }
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(width) {
            var frame = self.frame
            frame.size.width = width
            self.frame = frame
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(height) {
            var frame = self.frame
            frame.size.height = height
            self.frame = frame
        }
    }
    
    public var size: CGSize {
        get {
            return self.frame.size
        }
        set(size) {
            var frame = self.frame
            frame.size = size
            self.frame = frame
        }
    }
    
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(centerX) {
            var center = self.center
            center.x = centerX
            self.center = center
        }
    }
    
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(centerY) {
            var center = self.center
            center.y = centerY
            self.center = center
        }
    }
    
    public var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(top) {
            var frame = self.frame
            frame.origin.y = y
            self.frame = frame
        }
    }

    /** 获取最大x */
    func maxX() -> CGFloat {
        return self.x + self.width
    }

    /** 获取最小x */
    func minX() -> CGFloat {
        return self.x
    }
    
    /** 获取最大y */
    func maxY() -> CGFloat {
        return self.y + self.height
    }
    
    /** 获取最小y */
    func minY() -> CGFloat {
        return self.y
    }
}
