//
//  LSResizeView.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/7/13.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit

protocol LSResizeViewDelegate: AnyObject {
    func lsOptionalResizeConrolViewDidBeginResizing(_ resizeView: LSResizeView)
    func lsOptionalResizeConrolViewDidResize(_ resizeView: LSResizeView)
    func lsOptionalResizeConrolViewDidEndResizing(_ resizeView: LSResizeView)
}

class LSResizeView: UIView {
    
    weak var delegate: LSResizeViewDelegate?
    var translation: CGPoint = .zero
    var startPoint: CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: 44.0, height: 44.0))
        backgroundColor = .clear
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            let translationInView = gestureRecognizer.translation(in: superview)
            startPoint = CGPoint(x: CGFloat(roundf(Float(translationInView.x))), y: translationInView.y)
            delegate?.lsOptionalResizeConrolViewDidBeginResizing(self)
            
        case .changed:
            let translation = gestureRecognizer.translation(in: superview)
            self.translation = CGPoint(x: CGFloat(roundf(Float(startPoint.x + translation.x))), y: CGFloat(roundf(Float(startPoint.y + translation.y))))
            delegate?.lsOptionalResizeConrolViewDidResize(self)
            
        case .ended, .cancelled:
            delegate?.lsOptionalResizeConrolViewDidEndResizing(self)
            
        default:
            break
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
