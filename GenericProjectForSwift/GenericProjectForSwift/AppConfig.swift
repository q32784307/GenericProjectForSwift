//
//  AppConfig.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/12/21.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit


/****************************************************颜色****************************************************/
/**
 * 颜色
 */
func kRGBAColor(r: CGFloat,_ g: CGFloat,_ b: CGFloat,_ a: CGFloat) -> UIColor {
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: (a))
}
func RGBAColor(r: CGFloat,_ g: CGFloat,_ b: CGFloat,_ a: CGFloat) -> UIColor {
    return UIColor(red: (r), green: (g), blue: (b), alpha: (a))
}
/**
 * 页面底色
 */
let ViewBackgroundColor = kRGBAColor(r: 242.0, 242.0, 242.0, 1)
/**
 * rgb颜色转换（16进制->10进制）
 */
func ColorFromRGB(rgbValue: CGFloat) -> UIColor {
    return UIColor(red: ((CGFloat)((Int(rgbValue) & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((Int(rgbValue) & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(Int(rgbValue) & 0xFF))/255.0, alpha: 1.0)
}
let ClearColor = UIColor.clear
let WhiteColor = UIColor.white
let BlackColor = UIColor.black
let GrayColor = UIColor.gray
let BlueColor = UIColor.blue
let RedColor = UIColor.red
let CyanColor = UIColor.cyan
let YellowColor = UIColor.yellow
let OrangeColor = UIColor.orange
let PurpleColor = UIColor.purple
let BrownColor = UIColor.brown
let GreenColor = UIColor.green
let MagentaColor = UIColor.magenta
let DarkGrayColor = UIColor.darkGray
let LightGrayColor = UIColor.lightGray
//字体
func BoldSystemFont(FONTSIZE: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: FONTSIZE)
}
func SystemFont(FONTSIZE: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: FONTSIZE)
}
//定义UIImage对象
func ImageNamed(name: String) -> UIImage {
    return UIImage.init(named: name)!
}

/**************************************************屏幕适配**************************************************/
/**
 * 屏幕宽和高
 */
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let ScreenBounds = UIScreen.main.bounds
//判断横屏还是竖屏
let IsPortrait = UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown
func SYRealValue(value: CGFloat) ->CGFloat {
    return IsPortrait == true ? ((value) / 375.0 * ScreenWidth) : ((value) / 375.0 * ScreenHeight)
}
//----------------判断当前的iPhone设备/系统版本---------------
// 判断是否为iPhone
let IS_IPHONE = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
// 判断是否为iPad
let IS_IPAD = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)

//----------------判断系统版本---------------
// 获取系统版本
let IOS_SYSTEM_VERSION = Double(UIDevice.current.systemVersion)
// 判断 iOS 8 或更高的系统版本
let IOS_VERSION_8_OR_LATER = Double(UIDevice.current.systemVersion)! >= 8.0 ? true :false
// 判断 iOS 10 或更高的系统版本
let IOS_VERSION_10_OR_LATER = Double(UIDevice.current.systemVersion)! >= 10.0 ? true :false

// 判断iPhone 4/4S
let iPhone4_4S = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 960).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPAD : false)
// 判断iPhone 5/5S/5C/SE
let iPhone5_5SE = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 1136).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPAD : false)
// 判断iPhone 6/6S/7/8
let iPhone6_6S = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 750, height: 1334).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPAD : false)
// 判断iPhone 6Plus/6SPlus/7P/8P
let iPhone6Plus_8Plus = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1080, height: 1920).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPAD : false)
//判断iPhone X
let Is_iPhoneX = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPAD : false)
//判断iPHone Xr
let Is_iPhoneXr = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 828, height: 1792).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPAD : false)
//判断iPhone Xs
let Is_iPhoneXs = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPAD : false)
//判断iPhone Xs Max
let Is_iPhoneXs_Max = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2688).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPAD : false)
//判断iPhone 12和iPhone 12 Pro
let Is_iPhone12 = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1170, height: 2532).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPAD : false)
//判断iPhone 12 mini
let Is_iPhone12_mini = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1080, height: 2340).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPAD : false)
//判断iPhone 12 Pro Max
let Is_iPhone12_Pro_Max = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1284, height: 2778).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPAD : false)
//判断iPad mini
let Is_iPad_Mine = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1536, height: 2048).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPHONE : false)
//判断iPad
let Is_iPad = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1536, height: 2048).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPHONE : false)
//判断iPad Pro(10.5寸)
let Is_iPad_Pro_10_5 = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1668, height: 2224).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPHONE : false)
//判断iPad Pro(12.9寸)
let Is_iPad_Pro_12_9 = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 2048, height: 2732).equalTo((UIScreen.main.currentMode?.size)!) && !IS_IPHONE : false)

// 主要是用于区分是否是 刘海屏
//#define LiuHaiPhone \
//({BOOL isLiuHaiPhone = NO;\
//if (@available(iOS 11.0, *)) {\
//isLiuHaiPhone = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
//}\
//(isLiuHaiPhone);})
//
//状态栏高度
let STATUS_BAR_HEIGHT = ((Is_iPhoneX == true || Is_iPhoneXr == true || Is_iPhoneXs == true || Is_iPhoneXs_Max == true || Is_iPhone12 == true || Is_iPhone12_mini == true || Is_iPhone12_Pro_Max == true) ? 44.0 : 20.0)
//状态栏+导航栏高度
let NAVIGATION_BAR_HEIGHT = ((Is_iPhoneX == true || Is_iPhoneXr == true || Is_iPhoneXs == true || Is_iPhoneXs_Max == true || Is_iPhone12 == true || Is_iPhone12_mini == true || Is_iPhone12_Pro_Max == true) ? 88.0 : 64.0)
//tabBar高度
let TAB_BAR_HEIGHT = ((Is_iPhoneX == true || Is_iPhoneXr == true || Is_iPhoneXs == true || Is_iPhoneXs_Max == true || Is_iPhone12 == true || Is_iPhone12_mini == true || Is_iPhone12_Pro_Max == true) ? 83.0 : 49.0)
//home indicator高度（底部安全曲区域）
let HOME_INDICATOR_HEIGHT = ((Is_iPhoneX == true || Is_iPhoneXr == true || Is_iPhoneXs == true || Is_iPhoneXs_Max == true || Is_iPhone12 == true || Is_iPhone12_mini == true || Is_iPhone12_Pro_Max == true) ? 34.0 : 0.0)
///***********************************************************************************************************/
