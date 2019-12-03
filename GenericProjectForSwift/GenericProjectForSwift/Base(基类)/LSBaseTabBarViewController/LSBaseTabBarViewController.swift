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
    
    func setViewControllers() -> Void {
        let path:String = Bundle.main.path(forResource: "TabBarConfigure", ofType: "plist")!
        let dataArray:[[String:String]] = NSArray.init(contentsOfFile: path) as! [[String : String]]
        for dataDic in dataArray {
            print(dataDic["title"] as Any)
            let vcView = NSClassFromString(dataDic["class"]!) as! String
            let title = dataDic["title"]
            let image = dataDic["image"]
            let selectedImage = dataDic["selectedImage"]
            
            
        }
    }
    
    func addChild(classVC:String,title:String,image:String,selectedImage:String) {
        
    }
    
//    - (LSBaseNavigationViewController *)setViewController:(Class)class title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
//        UIViewController *vc = [class new];
//        vc.tabBarItem.title = title;
//
//        if (@available(iOS 13.0, *)) {
//            UITabBarAppearance *appearance = UITabBarAppearance.new;
//            NSMutableParagraphStyle *par = [[NSMutableParagraphStyle alloc]init];
//            par.alignment = NSTextAlignmentCenter;
//            //未选中状态
//            UITabBarItemStateAppearance *normal = appearance.stackedLayoutAppearance.normal;
//            if (normal) {
//                normal.titleTextAttributes = @{NSForegroundColorAttributeName:BlackColor,NSParagraphStyleAttributeName : par};
//            }
//            //选中状态
//            UITabBarItemStateAppearance *selected = appearance.stackedLayoutAppearance.selected;
//            if (selected) {
//                selected.titleTextAttributes = @{NSForegroundColorAttributeName:RedColor,NSParagraphStyleAttributeName : par};
//            }
//            self.tabBar.standardAppearance = appearance;
//        }else{
//            //未选中状态
//            NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//            textAttrs[NSForegroundColorAttributeName] = BlackColor;
//            textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
//            [vc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//            //选中状态
//            NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
//            selectedTextAttrs[NSForegroundColorAttributeName] = RedColor;
//            selectedTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
//            [vc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
//        }
//        vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//        //tabbar的背景色
//        [UITabBar appearance].backgroundColor = RGBAColor(0.98, 0.98, 0.98, 1);
//        //解决iOS12系统下pop返回时tabbar偏移的问题
//        [UITabBar appearance].translucent = NO;
//
//        LSBaseNavigationViewController *nav = [[LSBaseNavigationViewController alloc] initWithRootViewController:vc];
//        [self addChildViewController:nav];
//
//        //改变tabbar 线条颜色
//        CGRect rect = CGRectMake(0, 0, ScreenWidth, SYRealValue(2 / 2));
//        UIGraphicsBeginImageContext(rect.size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetFillColorWithColor(context,RGBAColor(0.99, 0.85, 0.92 ,1).CGColor);
//        CGContextFillRect(context, rect);
//        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        [self.tabBar setShadowImage:img];
//        [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
//
//
//        return nav;
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
