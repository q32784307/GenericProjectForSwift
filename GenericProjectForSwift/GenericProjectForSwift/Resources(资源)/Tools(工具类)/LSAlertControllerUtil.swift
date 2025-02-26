//
//  LSAlertControllerUtil.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/15.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit

class LSAlertControllerUtil {
    static func ls_showSingleButtonAlert(title: String, message: String, buttonTitle: String, buttonAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            buttonAction?()
        }

        alertController.addAction(action)
        
        ls_presentAlertController(alertController: alertController)
    }
    
    static func ls_showTwoButtonAlert(title: String, message: String, leftButtonTitle: String, leftButtonAction: (() -> Void)? = nil, rightButtonTitle: String, rightButtonAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let leftAction = UIAlertAction(title: leftButtonTitle, style: .default) { _ in
            leftButtonAction?()
        }
        
        alertController.addAction(leftAction)
        
        let rightAction = UIAlertAction(title: rightButtonTitle, style: .default) { _ in
            rightButtonAction?()
        }
        
        alertController.addAction(rightAction)
        
        ls_presentAlertController(alertController: alertController)
    }
    
    static func ls_showMultiButtonAlert(title: String, message: String, buttonInfos: [(title: String, action: (() -> Void)?)]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for buttonInfo in buttonInfos {
            let action = UIAlertAction(title: buttonInfo.title, style: .default) { _ in
                buttonInfo.action?()
            }
            
            alertController.addAction(action)
        }
        
        ls_presentAlertController(alertController: alertController)
    }
    
    static func ls_showAutoDismissAlert(title: String, message: String, duration: TimeInterval = 2.0, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        ls_presentAlertController(alertController: alertController)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alertController.dismiss(animated: true, completion: completion)
        }
    }
    
    static func ls_showMultiButtonActionSheet(title: String, message: String, buttonInfos: [(title: String, style: UIAlertAction.Style, action: (() -> Void)?)]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for buttonInfo in buttonInfos {
            let action = UIAlertAction(title: buttonInfo.title, style: buttonInfo.style) { _ in
                buttonInfo.action?()
            }
            
            alertController.addAction(action)
        }
        
        ls_presentAlertController(alertController: alertController)
    }
    
    static func ls_showAutoDismissingActionSheet(title: String, message: String, duration: TimeInterval = 2.0, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        ls_presentAlertController(alertController: alertController)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alertController.dismiss(animated: true, completion: completion)
        }
    }
    
    private static func ls_presentAlertController(alertController: UIAlertController) {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
