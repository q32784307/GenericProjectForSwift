//
//  LSAvatarBrowser.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/1.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//
//  点击放大图片
//  LSAvatarBrowser.ls_showImage(avatarImageView)

import UIKit

class LSAvatarBrowser {
    private static var oldframe = CGRect.zero

    class func ls_showImage(_ avatarImageView: UIImageView) {
        guard let image = avatarImageView.image,
              let window = UIApplication.shared.keyWindow else {
            return
        }

        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        oldframe = avatarImageView.convert(avatarImageView.bounds, to: window)
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        let imageView = UIImageView(frame: oldframe)
        imageView.image = image
        imageView.tag = 1
        backgroundView.addSubview(imageView)
        window.addSubview(backgroundView)

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideImage(_:)))
        backgroundView.addGestureRecognizer(tap)

        UIView.animate(withDuration: 0.3) {
            imageView.frame = CGRect(x: 0, y: (UIScreen.main.bounds.size.height - image.size.height * UIScreen.main.bounds.size.width / image.size.width) / 2, width: UIScreen.main.bounds.size.width, height: image.size.height * UIScreen.main.bounds.size.width / image.size.width)
            backgroundView.alpha = 1
        }
    }

    @objc class func hideImage(_ tap: UITapGestureRecognizer) {
        guard let backgroundView = tap.view,
              let imageView = backgroundView.viewWithTag(1) as? UIImageView else {
            return
        }

        UIView.animate(withDuration: 0.3, animations: {
            imageView.frame = oldframe
            backgroundView.alpha = 0
        }) { _ in
            backgroundView.removeFromSuperview()
        }
    }
}
