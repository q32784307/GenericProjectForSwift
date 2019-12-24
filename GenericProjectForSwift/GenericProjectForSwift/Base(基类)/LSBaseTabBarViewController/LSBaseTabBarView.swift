//
//  LSBaseTabBarView.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/12/22.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit

class LSBaseTabBarView: UITabBar {
    
    var MoreButton: UIButton!
    var oldSafeAreaInsets: UIEdgeInsets!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = WhiteColor
        
        MoreButton = UIButton.init()
        MoreButton.setBackgroundImage(ImageNamed(name: "plus"), for: .normal)
        MoreButton.addTarget(self, action: #selector(MoreAction), for: .touchUpInside)
        MoreButton.size = MoreButton.currentBackgroundImage!.size
        self.addSubview(MoreButton)
    }
    
    override func safeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super .safeAreaInsetsDidChange()
            if self.oldSafeAreaInsets.left != self.safeAreaInsets.left || self.oldSafeAreaInsets.right != self.safeAreaInsets.right || self.oldSafeAreaInsets.top != self.safeAreaInsets.top || self.oldSafeAreaInsets.bottom != self.safeAreaInsets.bottom {
                self.oldSafeAreaInsets = self.safeAreaInsets
                self.invalidateIntrinsicContentSize()
                self.superview?.setNeedsLayout()
                self.superview?.layoutSubviews()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func sizeThatFits(size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            let bottomInset = self.safeAreaInsets.bottom
            if bottomInset > 0 && size.height < 50 {
                size.height += bottomInset
            }
        } else {
            // Fallback on earlier versions
        }
        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        MoreButton.center = CGPoint(x: self.width * 0.5, y: self.height * 0.1)
        var index: Int = 0
        for view in self.subviews {
            if view.isKind(of: NSClassFromString("UITabBarButton")!) {
                view.width = self.width / 5
                view.x = view.width * CGFloat(index)
                index += 1
                if index == 2 {
                    index += 1
                }
            }
        }
    }
    
    func hitTestwithEvent(point: CGPoint,event: UIEvent) -> UIView {
        if self.isHidden == false {
            let newPoint: CGPoint = self.convert(point, to: self.MoreButton)
            if self.MoreButton.point(inside: newPoint, with: event) {
                return self.MoreButton
            }else{
                return super.hitTest(point, with: event)!
            }
        }else{
            return super.hitTest(point, with: event)!
        }
    }

    
    //点击了发布按钮
    @objc func MoreAction() {
        //如果tabbar的代理实现了对应的代理方法，那么就调用代理的该方法
//        if ([self.delegate respondsToSelector:@selector(tabBarMoreButtonAction:)]) {
//            [self.BarButtonDelegate tabBarMoreButtonAction:self];
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
