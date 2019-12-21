//
//  LSBaseTabBarViewController.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/11/30.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit

class LSBaseTabBarViewController: UITabBarController,UITabBarControllerDelegate {
    
    var lastItem: UITabBarItem!
    var dataArray: Array<Any>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lastItem = self.tabBar.selectedItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let bgView:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: 20))
        bgView.backgroundColor = UIColor.white
        self.tabBar.insertSubview(bgView, at: 0)
        self.delegate = self

        
        setViewControllers()
    }
    
    func setViewControllers()  {
        addChild(setChildViewController(viewController: OneViewController.self, title: "首页", image: "tabbar_home", selectedImage: "tabbar_home_selected"))
        addChild(setChildViewController(viewController: TwoViewController.self, title: "消息", image: "tabbar_message_center", selectedImage: "tabbar_message_center_selected"))
        addChild(setChildViewController(viewController: ThreeViewController.self, title: "发现", image: "tabbar_reward", selectedImage: "tabbar_reward_selected"))
        addChild(setChildViewController(viewController: FourViewController.self, title: "我的", image: "tabbar_profile", selectedImage: "tabbar_profile_selected"))
    }
    
    func setChildViewController(viewController: AnyObject.Type,title: String,image: String,selectedImage: String) -> LSBaseNavigationViewController {
        let vc = UIViewController.init()
        vc.tabBarItem.title = title
        
        //未选中状态
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : BlackColor,NSAttributedString.Key.font: SystemFont(FONTSIZE: 10)], for: .normal)
        vc.tabBarItem.image = ImageNamed(name: image).withRenderingMode(.alwaysOriginal)
        //选中状态
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : RedColor,NSAttributedString.Key.font: SystemFont(FONTSIZE: 10)], for: .selected)
        vc.tabBarItem.selectedImage = ImageNamed(name: selectedImage).withRenderingMode(.alwaysOriginal)
        
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().isTranslucent = false

        let nav = LSBaseNavigationViewController.init(rootViewController: vc)
        addChild(nav)
        
        //改变tabbar 线条颜色
        let rect = CGRect(x: 0, y: 0, width: ScreenWidth, height: SYRealValue(value: 2 / 2))
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(RGBAColor(r: 0.99, 085, 0.92, 1).cgColor)
        context!.addRect(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tabBar.shadowImage = img
        tabBar.backgroundImage = UIImage.init()
        
        
        return nav
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
