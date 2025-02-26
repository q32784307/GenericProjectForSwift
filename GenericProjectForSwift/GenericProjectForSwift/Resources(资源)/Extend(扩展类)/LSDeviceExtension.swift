//
//  LSDeviceExtension.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2024/11/15.
//

import UIKit

extension UIDevice {

    // 获取主窗口（兼容iOS 13及更高版本）
    private static func getMainWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                return nil
            }
            return window
        } else {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        }
    }

    // 顶部安全区高度
    static func ls_dev_safeDistanceTop() -> CGFloat {
        guard let window = getMainWindow() else { return 0 }
        return window.safeAreaInsets.top
    }

    // 底部安全区高度
    static func ls_dev_safeDistanceBottom() -> CGFloat {
        guard let window = getMainWindow() else { return 0 }
        return window.safeAreaInsets.bottom
    }

    // 顶部状态栏高度（包括安全区）
    static func ls_dev_statusBarHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let statusBarManager = windowScene.statusBarManager else {
                return 0
            }
            return statusBarManager.statusBarFrame.size.height
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }

    // 导航栏高度
    static func ls_dev_navigationBarHeight() -> CGFloat {
        return 44.0
    }

    // 状态栏+导航栏+安全区的高度
    static func ls_dev_navigationFullHeight() -> CGFloat {
        return ls_dev_statusBarHeight() + ls_dev_navigationBarHeight()
    }

    // 底部导航栏高度
    static func ls_dev_tabBarHeight() -> CGFloat {
        return 49.0
    }

    // 底部导航栏高度（包括安全区）
    static func ls_dev_tabBarFullHeight() -> CGFloat {
        return ls_dev_tabBarHeight() + ls_dev_safeDistanceBottom()
    }
}
