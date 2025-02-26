//
//  LSToast.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/14.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//
//  仿安卓的Toast弹窗
//  LSToast.ls_show(message: "This is a toasThis is a toasThi", position: .center)

import UIKit

// 枚举值定义 Toast 的位置
enum LSToastPosition {
    case top
    case center
    case bottom
}

class LSToast {
    private static var toastView: UIView?
    private static var overlayView: UIView?

    static func ls_show(message: String, position: LSToastPosition) {
        DispatchQueue.global(qos: .userInitiated).async {
            let toastContainer = ls_createToastContainerView()
            let toastLabel = ls_createToastLabel(with: message)

            toastContainer.addSubview(toastLabel)
            toastView = toastContainer

            let window = UIApplication.shared.windows.first { $0.isKeyWindow }

            // 创建半透明的黑色背景层
            overlayView = UIView(frame: window!.bounds)
            overlayView?.backgroundColor = LSWhiteColor.withAlphaComponent(0)
            overlayView?.isUserInteractionEnabled = true

            DispatchQueue.main.async {
                window?.addSubview(overlayView!)
                window?.addSubview(toastContainer)
                
                toastContainer.frame = CGRect(x: (window!.bounds.width - toastContainer.bounds.width) / 2,
                                              y: (window!.bounds.height - toastContainer.bounds.height) / 2,
                                              width: toastContainer.bounds.width,
                                              height: toastContainer.bounds.height)
                
                toastContainer.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.width.lessThanOrEqualToSuperview().offset(-LSSYRealValue(value: 40)) // 设置最大宽度

                    switch position {
                    case .top:
                        make.top.equalToSuperview().offset(UIDevice.ls_dev_navigationFullHeight() + LSSYRealValue(value: 20))
                        make.bottom.lessThanOrEqualTo(window!.snp.centerY)
                    case .center:
                        make.centerY.equalToSuperview()
                    case .bottom:
                        make.bottom.equalToSuperview().offset(-UIDevice.ls_dev_tabBarFullHeight() - LSSYRealValue(value: 20))
                        make.top.greaterThanOrEqualTo(window!.snp.centerY)
                    }
                }

                toastLabel.snp.makeConstraints { make in
                    make.edges.equalToSuperview().inset(UIEdgeInsets(top: LSSYRealValue(value: 10), left: LSSYRealValue(value: 10), bottom: LSSYRealValue(value: 10), right: LSSYRealValue(value: 10)))
                }

                // 立即应用约束
                toastContainer.layoutIfNeeded()

                toastContainer.alpha = 0.0
                UIView.animate(withDuration: 0.3, animations: {
                    toastContainer.alpha = 1.0
                }) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        UIView.animate(withDuration: 0.3, animations: {
                            toastContainer.alpha = 0.0
                        }, completion: { _ in
                            toastContainer.removeFromSuperview()
                            toastView = nil

                            overlayView?.removeFromSuperview()
                            overlayView = nil
                        })
                    }
                }
            }
        }
    }

    private static func ls_createToastContainerView() -> UIView {
        let toastContainer = UIView()
        toastContainer.backgroundColor = LSBlackColor.withAlphaComponent(0.8)
        toastContainer.layer.cornerRadius = LSSYRealValue(value: 10)
        toastContainer.clipsToBounds = true

        return toastContainer
    }

    private static func ls_createToastLabel(with message: String) -> LSBaseLabel {
        let toastLabel = LSBaseLabel.init()
        toastLabel.textColor = LSWhiteColor
        toastLabel.textAlignment = .center
        toastLabel.font = LSSystemFont(NAME: "Regular", FONTSIZE: LSSYRealValue(value: 16))
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.backgroundColor = LSClearColor

        return toastLabel
    }
}
