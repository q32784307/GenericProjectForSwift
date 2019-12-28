//
//  AppDelegate.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/11/30.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var visualEffectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .extraLight))
    
    var mainTabBar: LSBaseTabBarViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        // Override point for customization after application launch.
        window!.backgroundColor = UIColor.white
        
        let TabBarVC = LSBaseTabBarViewController()
        window!.rootViewController = TabBarVC;
        
        IQKeyboardManager.shared.enable = true
        
        window!.makeKeyAndVisible()
        TabBarVC.setBadgeValue(badgeValue: "11", index: 2)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        print("将要进入后台");
        
        //毛玻璃效果
        visualEffectView.alpha = 0
        visualEffectView.frame = window!.frame
        window?.addSubview(visualEffectView)
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 1
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("进入后台");
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("将要进入前台");
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("进入前台");
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
        }) { (Bool) in
            self.visualEffectView.removeFromSuperview()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

