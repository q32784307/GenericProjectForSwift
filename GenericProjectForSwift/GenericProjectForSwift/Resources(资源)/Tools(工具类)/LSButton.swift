//
//  LSButton.swift
//  GenericProjectForSwift
//
//  Created by 漠然丶情到深处 on 2023/5/26.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//
//  可以设置图片与文字位置，可以设置图片与文字的间距

import UIKit

enum LSImagePosition {
    case top
    case left
    case right
    case bottom
}

class LSButton: UIButton {
    
    var imagePosition: LSImagePosition = .left {
        didSet {
            updateLayout()
        }
    }
    
    var spacing: CGFloat = 10.0 {
        didSet {
            updateLayout()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let imageSize = imageView?.frame.size ?? CGSize.zero
        let titleSize = titleLabel?.frame.size ?? CGSize.zero
        
        switch imagePosition {
        case .top, .bottom:
            return CGSize(width: max(size.width, imageSize.width), height: size.height + titleSize.height + spacing)
        case .left, .right:
            return CGSize(width: size.width + imageSize.width + spacing, height: max(size.height, titleSize.height))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    private func updateLayout() {
        guard let imageView = imageView, let titleLabel = titleLabel else {
            return
        }
        
        switch imagePosition {
        case .top:
            imageView.frame.origin.x = (bounds.size.width - imageView.frame.size.width) / 2
            imageView.frame.origin.y = (bounds.size.height - (imageView.frame.size.height + titleLabel.frame.size.height + spacing)) / 2
            titleLabel.frame.origin.x = (bounds.size.width - titleLabel.frame.size.width) / 2
            titleLabel.frame.origin.y = imageView.frame.origin.y + imageView.frame.size.height + spacing
        case .bottom:
            titleLabel.frame.origin.x = (bounds.size.width - titleLabel.frame.size.width) / 2
            titleLabel.frame.origin.y = (bounds.size.height - (imageView.frame.size.height + titleLabel.frame.size.height + spacing)) / 2
            imageView.frame.origin.x = (bounds.size.width - imageView.frame.size.width) / 2
            imageView.frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.size.height + spacing
        case .left:
            imageView.frame.origin.x = (bounds.size.width - (imageView.frame.size.width + titleLabel.frame.size.width + spacing)) / 2
            imageView.frame.origin.y = (bounds.size.height - imageView.frame.size.height) / 2
            titleLabel.frame.origin.x = imageView.frame.origin.x + imageView.frame.size.width + spacing
            titleLabel.frame.origin.y = (bounds.size.height - titleLabel.frame.size.height) / 2
        case .right:
            titleLabel.frame.origin.x = (bounds.size.width - (imageView.frame.size.width + titleLabel.frame.size.width + spacing)) / 2
            titleLabel.frame.origin.y = (bounds.size.height - titleLabel.frame.size.height) / 2
            imageView.frame.origin.x = titleLabel.frame.origin.x + titleLabel.frame.size.width + spacing
            imageView.frame.origin.y = (bounds.size.height - imageView.frame.size.height) / 2
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
