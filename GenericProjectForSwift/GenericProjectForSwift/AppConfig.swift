//
//  AppConfig.swift
//  GenericProjectForSwift
//
//  Created by 漠然丶情到深处 on 2019/12/21.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit
import Foundation

/****************************************************颜色****************************************************/
/**
 * 颜色
 */
func LS_kRGBAColor(r: CGFloat,_ g: CGFloat,_ b: CGFloat,_ a: CGFloat) -> UIColor {
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: (a))
}
func LS_RGBAColor(r: CGFloat,_ g: CGFloat,_ b: CGFloat,_ a: CGFloat) -> UIColor {
    return UIColor(red: (r), green: (g), blue: (b), alpha: (a))
}
/**
 * 页面底色
 */
let LSViewBackgroundColor = LS_kRGBAColor(r: 247.0, 246.0, 250.0, 1)
/**
 * 主题色
 */
let LSThemeColor = LS_kRGBAColor(r: 240.0, 253.0, 255.0, 1)
                                 
/**
 * rgb颜色转换（16进制->10进制）
 */
func LSColorFromRGB(rgbValue: CGFloat) -> UIColor {
    return UIColor(red: ((CGFloat)((Int(rgbValue) & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((Int(rgbValue) & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(Int(rgbValue) & 0xFF))/255.0, alpha: 1.0)
}
let LSClearColor = UIColor.clear
let LSWhiteColor = UIColor.white
let LSBlackColor = UIColor.black
let LSGrayColor = UIColor.gray
let LSBlueColor = UIColor.blue
let LSRedColor = UIColor.red
let LSCyanColor = UIColor.cyan
let LSYellowColor = UIColor.yellow
let LSOrangeColor = UIColor.orange
let LSPurpleColor = UIColor.purple
let LSBrownColor = UIColor.brown
let LSGreenColor = UIColor.green
let LSMagentaColor = UIColor.magenta
let LSDarkGrayColor = UIColor.darkGray
let LSLightGrayColor = UIColor.lightGray
//字体
func LSSystemFont(NAME:String, FONTSIZE: CGFloat) -> UIFont {
    return UIFont(name: String(format: "PingFangSC-%@", NAME), size: FONTSIZE)!
}

func LSFontRegular(FONTSIZE: CGFloat) -> UIFont {
    return LSSystemFont(NAME: "Regular", FONTSIZE: FONTSIZE)
}

func LSFontMedium(FONTSIZE: CGFloat) -> UIFont {
    return LSSystemFont(NAME: "Medium", FONTSIZE: FONTSIZE)
}

func LSFontSemibold(FONTSIZE: CGFloat) -> UIFont {
    return LSSystemFont(NAME: "Semibold", FONTSIZE: FONTSIZE)
}

//定义UIImage对象
func LSImageNamed(name: String) -> UIImage {
    return UIImage.init(named: name)!
}

/**************************************************屏幕适配**************************************************/
/**
 * 屏幕宽和高
 */
let LSScreenWidth = UIScreen.main.bounds.size.width
let LSScreenHeight = UIScreen.main.bounds.size.height
let LSScreenBounds = UIScreen.main.bounds

func LSSYRealValue(value: CGFloat) -> CGFloat {
    return floor((value / 375.0) * LSScreenWidth)
}

//----------------判断系统版本---------------
// 获取系统版本
let IOS_SYSTEM_VERSION = Double(UIDevice.current.systemVersion)

/// 顶部安全区高度
func LSSafeDistanceTop() -> CGFloat {
    if #available(iOS 13.0, *) {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return 0 }
        guard let window = windowScene.windows.first else { return 0 }
        return window.safeAreaInsets.top
    } else if #available(iOS 11.0, *) {
        guard let window = UIApplication.shared.windows.first else { return 0 }
        return window.safeAreaInsets.top
    }
    return 0;
}

/// 底部安全区高度
func LSSafeDistanceBottom() -> CGFloat {
    if #available(iOS 13.0, *) {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return 0 }
        guard let window = windowScene.windows.first else { return 0 }
        return window.safeAreaInsets.bottom
    } else if #available(iOS 11.0, *) {
        guard let window = UIApplication.shared.windows.first else { return 0 }
        return window.safeAreaInsets.bottom
    }
    return 0;
}

/// 顶部状态栏高度（包括安全区）
func LSSTATUS_BAR_HEIGHT() -> CGFloat {
    var statusBarHeight: CGFloat = 0
    if #available(iOS 13.0, *) {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return 0 }
        guard let statusBarManager = windowScene.statusBarManager else { return 0 }
        statusBarHeight = statusBarManager.statusBarFrame.height
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statusBarHeight
}

/// 导航栏高度
func LSNAVIGATION_BAR_HEIGHT() -> CGFloat {
    return 44.0
}

/// 状态栏+导航栏的高度
func LSNAVIGATION_STATUS_HEIGHT() -> CGFloat {
    return LSSTATUS_BAR_HEIGHT() + LSNAVIGATION_BAR_HEIGHT()
}

/// 底部导航栏高度
func LSTAB_BAR_HEIGHT() -> CGFloat {
    return 49.0
}

/// 底部导航栏高度（包括安全区）
func LSTAB_HOME_HEIGHT() -> CGFloat {
    return LSTAB_BAR_HEIGHT() + LSSafeDistanceBottom()
}
///***********************************************************************************************************/

/************************************************自定义打印************************************************/
func LSNSLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
    let file2 = (file as NSString).lastPathComponent
    DispatchQueue.global(qos: .background).async {
        print("***开始***\n类名:\(file2)\n方法名:[\(funcName)](第\(lineNum)行)\n\(message)\n***结束***")
    }
    #endif
}
///***********************************************************************************************************/

/************************************************通知************************************************/
// 创建通知
func LSAddNotification(observer: Any, selector: Selector, key: String) {
    NotificationCenter.default.addObserver(observer, selector: selector, name: Notification.Name(key), object: nil)
}

// 发送通知
func LSSendNotification(key: String) {
    NotificationCenter.default.post(name: Notification.Name(key), object: nil, userInfo: nil)
}

// 移除通知
func LSRemoveNotification(observer: Any, key: String) {
    NotificationCenter.default.removeObserver(observer, name: Notification.Name(key), object: nil)
}
///***********************************************************************************************************/

/************************************************本地储存************************************************/
///// 存
func LSSaveUserDefault(obj: Any, key: String) {
    UserDefaults.standard.set(obj, forKey: key)
    UserDefaults.standard.synchronize()
}

func LSSaveUserDefaultBool(value: Bool, forKey key: String) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

// 取
func LSGetUserDefault(key: String) -> Any? {
    return UserDefaults.standard.object(forKey: key)
}

func LSGetUserDefaultBool(forKey key: String) -> Bool {
    return UserDefaults.standard.bool(forKey: key)
}

// 删除
func LSRemoveUserDefault(key: String) {
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}
///***********************************************************************************************************/

/************************************************判断数据是否为空************************************************/
import Foundation

// 字符串是否为空
func LSIsNilString(_ string: Any?) -> Bool {
    return (string as? String)?.isEmpty ?? true
}

// 数组是否为空
func LSIsNullArray(_ array: Any?) -> Bool {
    return (array as? [Any])?.isEmpty ?? true
}

// 字典是否为空
func LSIsNullDict(_ dictionary: Any?) -> Bool {
    return (dictionary as? [AnyHashable: Any])?.isEmpty ?? true
}

// 是否是空对象
func LSIsNullObject(_ object: Any?) -> Bool {
    return (object as? Data)?.isEmpty ?? false || (object as? [Any])?.isEmpty ?? false
}

// 示例用法
//let emptyString: String? = nil
//let nonEmptyString: String? = "Hello, World!"
//
//if LSIsNilString(emptyString) {
//    print("Empty string is nil or empty")
//} else {
//    print("Empty string is not nil or empty")
//}
//
//if LSIsNilString(nonEmptyString) {
//    print("Non-empty string is nil or empty")
//} else {
//    print("Non-empty string is not nil or empty")
//}
//
//let emptyArray: [Any]? = nil
//let nonEmptyArray: [Any]? = [1, 2, 3]
//
//if LSIsNullArray(emptyArray) {
//    print("Empty array is nil or empty")
//} else {
//    print("Empty array is not nil or empty")
//}
//
//if LSIsNullArray(nonEmptyArray) {
//    print("Non-empty array is nil or empty")
//} else {
//    print("Non-empty array is not nil or empty")
//}
//
//let emptyDict: [AnyHashable: Any]? = nil
//let nonEmptyDict: [AnyHashable: Any]? = ["key": "value"]
//
//if LSIsNullDict(emptyDict) {
//    print("Empty dictionary is nil or empty")
//} else {
//    print("Empty dictionary is not nil or empty")
//}
//
//if LSIsNullDict(nonEmptyDict) {
//    print("Non-empty dictionary is nil or empty")
//} else {
//    print("Non-empty dictionary is not nil or empty")
//}
//
//let emptyObject: Any? = nil
//let nonEmptyObject: Any? = "Some Value"
//
//if LSIsNullObject(emptyObject) {
//    print("Empty object is nil or empty")
//} else {
//    print("Empty object is not nil or empty")
//}
//
//if LSIsNullObject(nonEmptyObject) {
//    print("Non-empty object is nil or empty")
//} else {
//    print("Non-empty object is not nil or empty")
//}
///***********************************************************************************************************/
