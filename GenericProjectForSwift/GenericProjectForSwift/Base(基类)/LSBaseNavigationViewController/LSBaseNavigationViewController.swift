//
//  LSBaseNavigationViewController.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/12/3.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit

class LSBaseNavigationViewController: UINavigationController,UIGestureRecognizerDelegate,UINavigationControllerDelegate {

    var popDelegate: AnyObject!
    var popRecognizer: UIScreenEdgePanGestureRecognizer!
    var isSystemSlidBack: Bool!//是否开启系统右滑返回

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //默认开启系统右划返回
        interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self
    }
    
    //解决手势失效问题
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if isSystemSlidBack {
            self.interactivePopGestureRecognizer?.isEnabled = true
            popRecognizer.isEnabled = false
        }else{
            self.interactivePopGestureRecognizer?.isEnabled = false
            popRecognizer.isEnabled = true
        }
    }
    
    //根视图禁用右划返回
    private func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.children.count == 1 ? false : true
    }

    //push时隐藏tabbar
    override func pushViewController(_ viewController: UIViewController,animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
//        // 修改tabBra的frame
//        var frame: CGRect = (self.tabBarController?.tabBar.frame)!
//        frame.origin.y = UIScreen.main.bounds.size.height - frame.size.height
//        self.tabBarController?.tabBar.frame = frame
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: LSBaseViewController.self) {
            let vc: LSBaseViewController = viewController as! LSBaseViewController
            if vc.isHidenNaviBar {
                vc.view.top = 0
                vc.navigationController?.setNavigationBarHidden(true, animated: animated)
            }else{
                vc.view.top = CGFloat(NAVIGATION_BAR_HEIGHT)
                vc.navigationController?.setNavigationBarHidden(false, animated: animated)
            }
        }
    }
    
    /**
     *  返回到指定的类视图
     *
     *  @param ClassName 类名
     *  @param animated  是否动画
     */
    func popToAppointViewController(ClassName: String,animated: Bool) -> Bool {
        let vc = getCurrentViewControllerClass(ClassName: ClassName)
        if vc != nil && (vc?.isKind(of: UIViewController.self))! {
            popToViewController(vc!, animated: animated)
            return true
        }
        return false
    }

    /*!
     *  获得当前导航器显示的视图
     *
     *  @param ClassName 要获取的视图的名称
     *
     *  @return 成功返回对应的对象，失败返回nil;
     */
    func getCurrentViewControllerClass(ClassName: String) -> Self! {
        let classObj:AnyClass = NSClassFromString(ClassName)!
        
        let szArray: Array = viewControllers
        for vc: AnyObject in szArray {
            if vc.isMember(of: classObj) {
                return (vc as! Self)
            }
        }
        
        return nil
    }
    
    func childViewControllerForStatusBarStyle() -> UIViewController {
        return self.topViewController!
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
