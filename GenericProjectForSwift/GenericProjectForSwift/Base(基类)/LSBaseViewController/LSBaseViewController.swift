//
//  LSBaseViewController.swift
//  GenericProjectForSwift
//
//  Created by 漠然丶情到深处 on 2019/12/21.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit

class LSBaseViewController: UIViewController {
    
    //是否隐藏系统导航栏
    var isHidenNaviBar: Bool = false {
        didSet {
            self.navigationController?.setNavigationBarHidden(isHidenNaviBar, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        isHidenNaviBar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.keyWindow?.endEditing(true)
        
//        isHidenNaviBar = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LSViewBackgroundColor
        // Do any additional setup after loading the view.
    
        setNavigationView()
    }
    
    //创建自定义导航栏
    func setNavigationView() {
        //系统导航
        if #available(iOS 13.0, *) {
            let barApp = UINavigationBarAppearance()
            barApp.backgroundColor = LSWhiteColor
            barApp.backgroundEffect = nil
            barApp.shadowColor = LSWhiteColor
            self.navigationController?.navigationBar.scrollEdgeAppearance = barApp
            self.navigationController?.navigationBar.standardAppearance = barApp
        }
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.shadowColor = LSColorUtil.ls_colorWithHexString(color: "000000", alpha: 0.05).cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSizeMake(0, 4)
        self.navigationController?.navigationBar.layer.shadowOpacity = 1
        self.navigationController?.navigationBar.layer.shadowRadius = 20
        self.navigationController?.navigationBar.layer.shadowPath = UIBezierPath(rect: (self.navigationController?.navigationBar.bounds)!).cgPath
        
        if self != self.navigationController?.viewControllers.first {
            let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: LSSYRealValue(value: 24), height: LSSYRealValue(value: 24)))
            leftButton.setImage(LSImageNamed(name: "back_black"), for: UIControl.State.normal)
            leftButton.adjustsImageWhenHighlighted = false
            leftButton.addTarget(self, action: #selector(backPopAction), for: UIControl.Event.touchUpInside)
            
            let leftView = UIView(frame: leftButton.frame)
            leftView.addSubview(leftButton)
            
            let leftBarButton = UIBarButtonItem(customView: leftView)
            self.navigationItem.leftBarButtonItem = leftBarButton
        }
    }
    
    @objc func backPopAction() {
        if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
//    //请求数据
//    func analysis() {
//        
//    }
//
//    //创建布局
//    func createSubViews() {
//        
//    }
    
    /** 该方法在UIView的分类中实现 */
    func isShowingOnKeyWindow() -> Bool {
        //主窗口
        let keyWindow: UIWindow = UIApplication.shared.keyWindow!
        // 以主窗口左上角为坐标原点, 计算self的矩形框
        let newFrame: CGRect = keyWindow.convert(self.view.frame, from: self.view.superview)
        let winBounds: CGRect = keyWindow.bounds
        
        // 主窗口的bounds 和 self的矩形框 是否有重叠
        let intersects: Bool = newFrame.intersects(winBounds)
        return !self.view.isHidden && self.view.alpha > 0.01 && self.view.window == keyWindow && intersects
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
