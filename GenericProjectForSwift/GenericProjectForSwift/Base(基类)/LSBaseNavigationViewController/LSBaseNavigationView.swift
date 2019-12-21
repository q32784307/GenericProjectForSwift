//
//  LSBaseNavigationView.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/12/21.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit

class LSBaseNavigationView: UIView {
    //导航栏
    var navView: UIView!
    //是否显示导航栏(默认YES显示)
    var isShowNavigation: Bool!
    //导航栏颜色
    var navColor: UIColor!
    //导航栏背景图
    var navBackgroundViewImage: String!
    //左按钮
    var leftButton: UIButton!
    //导航栏标题
    var titleLabel: UILabel!
    
    
    
    override init(frame: CGRect) {
        var selfFrame: CGRect = frame
        selfFrame.size.height = CGFloat(NAVIGATION_BAR_HEIGHT)
        
        super.init(frame: selfFrame)
        setNavigationViewAction()
    }
    
    func setNavigationViewAction() {
        //导航栏
        navView = UIView.init(frame: self.bounds)
        navView.isUserInteractionEnabled = true
        //是否显示
        if !self.isShowNavigation {
            navView.isHidden = false
        }else{
            navView.isHidden = true
        }
        //颜色
        if self.navColor != nil {
            navView.backgroundColor = RGBAColor(r: 0.22, 0.22, 0.24, 1)
        }else{
            navView.backgroundColor = self.navColor
        }
        //背景图片
        if self.navBackgroundViewImage != nil {
            navView.layer.contents = UIImage.init(named: "")?.cgImage
        }else{
            navView.layer.contents = UIImage.init(named: self.navBackgroundViewImage)?.cgImage
        }
        self.addSubview(navView)
        
//        //左按钮
//        leftButton = UIButton.init()
        
        //导航栏标题
        titleLabel = UILabel.init()
        //文字
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
