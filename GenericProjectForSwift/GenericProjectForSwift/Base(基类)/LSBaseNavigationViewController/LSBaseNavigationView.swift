//
//  LSBaseNavigationView.swift
//  GenericProjectForSwift
//
//  Created by 漠然丶情到深处 on 2019/12/21.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit
import SnapKit

class LSBaseNavigationView: UIView {
    //导航栏
    var navView: UIView!
    //是否显示导航栏(默认YES显示)
    var isShowNavigation: Bool! {
        didSet {
            navView.isHidden = isShowNavigation
        }
    }
    //导航栏颜色
    var navColor: UIColor! {
        didSet {
            navView.backgroundColor = navColor
        }
    }
    //导航栏背景图
    var navBackgroundViewImage: String! {
        didSet {
            navView.layer.contents = navBackgroundViewImage
        }
    }
    //左按钮
    var leftButton: UIButton!
    //左按钮图片
    var leftButtonImage: String! {
        didSet {
            leftButton.setImage(UIImage.init(named: leftButtonImage), for: .normal)
        }
    }
    //左按钮文字
    var leftButtonTitle: String! {
        didSet {
            leftButton.setTitle(leftButtonTitle, for: .normal)
        }
    }
    //左按钮文字颜色
    var leftButtonTitleColor: UIColor! {
        didSet {
            leftButton.setTitleColor(leftButtonTitleColor, for: .normal)
        }
    }
    //是否显示左按钮(默认YES显示)
    var isShowLeftButton: Bool! {
        didSet {
            leftButton.isHidden = isShowLeftButton
        }
    }
    //左按钮点击事件回调
    typealias leftButtonBlock = () ->()
    var leftActionBlock: leftButtonBlock!
    //导航栏标题
    var titleLabel: UILabel!
    //标题文字
    var titleLabelText: String! {
        didSet {
            titleLabel.text = titleLabelText
        }
    }
    //标题文字颜色
    var titleLabelTextColor: UIColor! {
        didSet {
            titleLabel.textColor = titleLabelTextColor
        }
    }
    //右按钮
    var rightButton: UIButton!
    //右按钮图片
    var rightButtonImage: String! {
        didSet {
            rightButton.setImage(UIImage.init(named: rightButtonImage), for: .normal)
        }
    }
    //右按钮文字
    var rightButtonTitle: String! {
        didSet {
            rightButton.setTitle(rightButtonTitle, for: .normal)
        }
    }
    //右按钮文字颜色
    var rightButtonTitleColor: UIColor! {
        didSet {
            rightButton.setTitleColor(rightButtonTitleColor, for: .normal)
        }
    }
    //是否显示右按钮(默认YES显示)
    var isShowRightButton: Bool! {
        didSet {
            rightButton.isHidden = isShowRightButton
        }
    }
    //右按钮点击事件回调
    typealias rightButtonBlock = () ->()
    var rightActionBlock: rightButtonBlock!
    
    
    override init(frame: CGRect) {
        var selfFrame: CGRect = frame
        selfFrame.size.height = CGFloat(LSNAVIGATION_STATUS_HEIGHT())
        
        leftButtonImage = "back_white"
        leftButtonTitle = "返回"
        leftButtonTitleColor = LSWhiteColor
        isShowLeftButton = false
        
        isShowNavigation = false
        navColor = LS_RGBAColor(r: 0.22, 0.22, 0.24, 1)
        navBackgroundViewImage = ""
        titleLabelText = "标题"
        titleLabelTextColor = LSWhiteColor
        
        rightButtonImage = ""
        rightButtonTitle = "完成"
        rightButtonTitleColor = LSWhiteColor
        isShowRightButton = true
        
        super.init(frame: selfFrame)
        setNavigationViewAction()
    }
    
    func setNavigationViewAction() {
        //导航栏
        navView = UIView.init(frame: CGRect(x: 0, y: 0, width: LSScreenWidth, height: CGFloat(LSNAVIGATION_STATUS_HEIGHT())))
        navView.isUserInteractionEnabled = true
        //是否显示
        navView.isHidden = isShowNavigation
        //颜色
        navView.backgroundColor = navColor
        //背景图片
        navView.layer.contents = UIImage.init(named: navBackgroundViewImage)?.cgImage
        self.addSubview(navView)
        
        //左按钮
        leftButton = UIButton.init()
        //图片
        leftButton.setImage(UIImage.init(named: leftButtonImage), for: .normal)
        leftButton.imageView?.contentMode = ContentMode.scaleAspectFit
        //文字
        leftButton.setTitle(leftButtonTitle, for: .normal)
        leftButton.titleLabel?.font = LSSystemFont(NAME: "Regular", FONTSIZE: LSSYRealValue(value: 14))
        //颜色
        leftButton.setTitleColor(leftButtonTitleColor, for: .normal)
        leftButton.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        //是否显示
        leftButton.isHidden = isShowLeftButton
        navView.addSubview(leftButton)
        leftButton.snp.makeConstraints { (make) in
            make.top.equalTo(navView).offset(LSSTATUS_BAR_HEIGHT() + LSSYRealValue(value: 11))
            make.left.equalTo(navView).offset(LSSYRealValue(value: 16))
            make.height.equalTo(LSSYRealValue(value: 20))
        }
        
        //导航栏标题
        titleLabel = UILabel.init()
        //文字
        titleLabel.text = titleLabelText
        //颜色
        titleLabel.textColor = titleLabelTextColor
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = LSSystemFont(NAME: "Medium", FONTSIZE: LSSYRealValue(value: 16))
        navView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(LSSTATUS_BAR_HEIGHT())
            make.centerX.equalTo(navView)
            make.size.equalTo(CGSize(width: LSSYRealValue(value: 300), height: LSNAVIGATION_BAR_HEIGHT()))
        }
        
        //右按钮
        rightButton = UIButton.init()
        //图片
        rightButton.setImage(UIImage.init(named: rightButtonImage), for: .normal)
        rightButton.imageView?.contentMode = ContentMode.scaleAspectFit
        //文字
        rightButton.setTitle(rightButtonTitle, for: .normal)
        rightButton.titleLabel?.font = LSSystemFont(NAME: "Regular", FONTSIZE: LSSYRealValue(value: 14))
        //颜色
        rightButton.setTitleColor(rightButtonTitleColor, for: .normal)
        rightButton.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        //是否显示
        rightButton.isHidden = isShowRightButton
        navView.addSubview(rightButton)
        rightButton.snp.makeConstraints { (make) in
            make.top.equalTo(navView).offset(LSSTATUS_BAR_HEIGHT() + LSSYRealValue(value: 11))
            make.right.equalTo(navView.snp.right).offset(LSSYRealValue(value: -16))
            make.height.equalTo(LSSYRealValue(value: 20))
        }
    }
    
    @objc func leftAction() {
        if leftActionBlock != nil {
            leftActionBlock()
        }
    }
    
    @objc func rightAction() {
        if rightActionBlock != nil {
            rightActionBlock()
        }
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
