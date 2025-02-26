//
//  AppDelegate.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/1.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit

extension AppDelegate {
    func ls_UMeng_application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // UMConfigure 通用设置，请参考SDKs集成做统一初始化。
        UMConfigure.initWithAppkey("", channel: "")
        UMConfigure.setLogEnabled(true)
        // U-Share 平台设置
        configUSharePlatforms()
        confitUShareSettings()
        
        return true
    }
    
    // 设置系统回调
    // 支持所有iOS系统
    func ls_UMeng_application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        let result = UMSocialManager.default().handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
        if !result {
            // 其他如支付等SDK的回调
        }
        
        return result
    }
    
    // 仅支持iOS9以上系统，iOS8及以下系统不会回调
    func ls_UMeng_application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        let result = UMSocialManager.default().handleOpen(url, options: options)
        if !result {
            // 其他如支付等SDK的回调
        }
        return result
    }
    
    // 2.支持目前所有iOS系统
    func ls_UMeng_application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        if !result {
            // 其他如支付等SDK的回调
        }
        return result
    }
    
    func confitUShareSettings() {
        /*
         * 打开图片水印
         */
        //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
        /*
         * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
         <key>NSAppTransportSecurity</key>
         <dict>
         <key>NSAllowsArbitraryLoads</key>
         <true/>
         </dict>
         */
        //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    }
    
    func configUSharePlatforms() {
        /* 设置微信的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxd8942a7d66db357e" appSecret:@"b604b445a6bea9256dc872384d9567aa" redirectURL:@"http://mobile.umeng.com/social"];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:@"wxd8942a7d66db357e" appSecret:@"b604b445a6bea9256dc872384d9567aa" redirectURL:@"http://mobile.umeng.com/social"];
//    /*设置小程序回调app的回调*/
//    [[UMSocialManager defaultManager] setLauchFromPlatform:(UMSocialPlatformType_WechatSession) completion:^(id userInfoResponse,NSError *error) {
//        NSLog(@"setLauchFromPlatform:userInfoResponse:%@",userInfoResponse);
//    }];
        UMSocialGlobal.shareInstance().universalLinkDic = [
            UMSocialPlatformType.wechatSession.rawValue: "",
            UMSocialPlatformType.QQ.rawValue: "",
            UMSocialPlatformType.sina.rawValue: ""
        ]
        /*
         * 移除相应平台的分享，如微信收藏
         */
        //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
        /* 设置分享到QQ互联的appID
         * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
         */
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: "", appSecret: "", redirectURL: "")
    }
}
