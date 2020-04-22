//
//  LSBaseTabBarViewController.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/11/30.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit
import AudioToolbox

class LSBaseTabBarViewController: UITabBarController,UITabBarControllerDelegate {
    
    var lsIndex: Int!
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
//        setCustomtabbar()
        removeTabarTopLine()
    }
    
    //设置自定义中心按钮
    func setCustomtabbar() {
        let tabbar = LSBaseTabBarView.init()
        self.setValue(tabbar, forKey: "tabBar")
    }
//    - (void)setCustomtabbar {
//        LSBaseTabBarView *tabbar = [[LSBaseTabBarView alloc]init];
//        tabbar.BarButtonDelegate = self;
//        [self setValue:tabbar forKeyPath:@"tabBar"];
//    }
    
    func setViewControllers()  {
        let path:String = Bundle.main.path(forResource: "TabBarConfigure", ofType: "plist")!
        let dataArray:[[String:String]] = NSArray.init(contentsOfFile: path) as! [[String : String]]
        for dataDic in dataArray {
            let vcView = dataDic["class"]
            let title = dataDic["title"]
            let image = dataDic["image"]
            let selectedImage = dataDic["selectedImage"]
            
            addChild(setChildViewController(viewController: vcView!, title: title!, image: image!, selectedImage: selectedImage!))
        }
    }
    
    func setChildViewController(viewController: String,title: String,image: String,selectedImage: String) -> LSBaseNavigationViewController {
        let cls:AnyClass? = NSClassFromString(Bundle.main.infoDictionary!["CFBundleExecutable"] as! String + "." + viewController)
        let vcCls = cls as! UIViewController.Type
        let vc = vcCls.init()
        vc.tabBarItem.title = title
        
        if #available(iOS 13.0, *) {
            UITabBar.appearance().tintColor = RedColor
        }
            
        //未选中状态
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : BlackColor,NSAttributedString.Key.font: SystemFont(FONTSIZE: 10)], for: .normal)
        vc.tabBarItem.image = ImageNamed(name: image).withRenderingMode(.alwaysOriginal)
        //选中状态
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : RedColor,NSAttributedString.Key.font: SystemFont(FONTSIZE: 10)], for: .selected)
        vc.tabBarItem.selectedImage = ImageNamed(name: selectedImage).withRenderingMode(.alwaysOriginal)
        
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().isTranslucent = false

        let nav = LSBaseNavigationViewController(rootViewController: vc)
        addChild(nav)
        
        
        return nav
    }
    
    //改变tabbar线条颜色
    func removeTabarTopLine() {
        let rect = CGRect(x: 0, y: 0, width: ScreenWidth, height: SYRealValue(value: 2 / 2))
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(RGBAColor(r: 0.99, 085, 0.92, 1).cgColor)
        context!.addRect(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tabBar.shadowImage = img
        tabBar.backgroundImage = UIImage.init()
    }
    
    //点击tabbarItem自动调用
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = (self.tabBar.items! as NSArray).index(of: item)
        if index != lsIndex {
            playNotifySound()
            lsIndex = index
        }
        animationWithIndex(index: index)
        
        if index == 0 {
            if item == lastItem {
                NotificationCenter.default.post(name: NSNotification.Name("0"), object: nil, userInfo: nil)
            }
            lastItem = item
        }else if index == 1 {
            if item == lastItem {
                NotificationCenter.default.post(name: NSNotification.Name("1"), object: nil, userInfo: nil)
            }
            lastItem = item
        }else if index == 2 {
            if item == lastItem {
                NotificationCenter.default.post(name: NSNotification.Name("2"), object: nil, userInfo: nil)
            }
            lastItem = item
        }else if index == 3 {
            if item == lastItem {
                NotificationCenter.default.post(name: NSNotification.Name("3"), object: nil, userInfo: nil)
            }
            lastItem = item
        }
    }
    
    //tabbar按钮点击动画
    func animationWithIndex(index: Int) {
        let tabbarbuttonArray = NSMutableArray.init()
        for tabBarButton in self.tabBar.subviews {
            if tabBarButton.isKind(of: NSClassFromString("UITabBarButton")!) {
                tabbarbuttonArray.add(tabBarButton as Any)
            }
        }
        /**
         CABasicAnimation类的使用方式就是基本的关键帧动画。
         所谓关键帧动画，就是将Layer的属性作为KeyPath来注册，指定动画的起始帧和结束帧，然后自动计算和实现中间的过渡动画的一种动画方式。
         */
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulse.duration = 0.2
        pulse.repeatCount = 1
        pulse.autoreverses = true
        pulse.fromValue = NSNumber(floatLiteral: 0.7)
        pulse.toValue = NSNumber(floatLiteral: 1.3)

        if #available(iOS 13.0, *) {
            let tabbarbuttonView = (tabbarbuttonArray[index] as AnyObject).layer
            tabbarbuttonView?.add(pulse, forKey: nil)
        } else {
            // Fallback on earlier versions
        }
    }

    //tabbar按钮点击声音
    func playNotifySound() {
        //获取路径
        let path = Bundle.main.path(forResource: "error", ofType: "wav")
        //定义一个带振动的SystemSoundID
        var soundID: SystemSoundID = 1000
        //判断路径是否存在
        if (path != nil) {
            //创建一个音频文件的播放系统声音服务器
            let error = AudioServicesCreateSystemSoundID(URL(fileURLWithPath: path!) as CFURL, &soundID)
            //判断是否有错误
            if error != kAudioServicesNoError {
                
            }
        }
        //只播放声音，没振动
        AudioServicesPlaySystemSound(soundID)
    }
    
    //设置小红点数值
    //设置指定tabar 小红点的值
    func setBadgeValue(badgeValue: String,index: Int) {
        if index + 1 > self.viewControllers!.count || index < 0 {
            //越界或者数据异常直接返回
            return
        }
        
        let base: LSBaseNavigationViewController = self.viewControllers![index] as! LSBaseNavigationViewController
        if base.viewControllers.count == 0 {
            return
        }
        
        let vc: UIViewController = base.viewControllers[0]
        vc.tabBarItem.badgeValue = (badgeValue as NSString).intValue > 0 ? badgeValue : nil
    }

    //设置小红点显示或者隐藏
    //显示小红点 没有数值
    func showBadgeWithIndex(index: Int) {
        self.tabBar.showBadgeOnItemIndex(index: index)
    }
    //隐藏小红点 没有数值
    func hideBadgeWithIndex(index: Int) {
        self.tabBar.hideBadgeOnItemIndex(index: index)
    }
    
    class MyTabBar: UITabBar {
        //让图片和文字在iOS11下仍然保持上下排列
        override open var traitCollection: UITraitCollection {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return UITraitCollection(horizontalSizeClass: .compact)
            }
            return super.traitCollection
        }
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
