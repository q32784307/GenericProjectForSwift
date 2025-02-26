//
//  LSCropRectView.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/7/13.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit

protocol LSCropRectViewDelegate: AnyObject {
    func lsOptionalCropRectViewDidBeginEditing(_ cropRectView: LSCropRectView)
    func lsOptionalCropRectViewEditingChanged(_ cropRectView: LSCropRectView)
    func lsOptionalCropRectViewDidEndEditing(_ cropRectView: LSCropRectView)
}

class LSCropRectView: UIView, LSResizeViewDelegate {
    
    weak var delegate: LSCropRectViewDelegate?
    var topLeftCornerView: LSResizeView!
    var topRightCornerView: LSResizeView!
    var bottomLeftCornerView: LSResizeView!
    var bottomRightCornerView: LSResizeView!
    var topEdgeView: LSResizeView!
    var leftEdgeView: LSResizeView!
    var bottomEdgeView: LSResizeView!
    var rightEdgeView: LSResizeView!
    var initialRect: CGRect = .zero
    var liveResizing: Bool = false
    var firstRecordRect: CGRect = .zero
    var isRecord: Bool = false
    
    var showsGridMajor: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var showsGridMinor: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentMode = .redraw
        
        showsGridMajor = true
        showsGridMinor = false
        isRecord = false
        
        let imageView = UIImageView(frame: bounds.insetBy(dx: -2.0, dy: -2.0))
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.image = UIImage(named: "PhotoCropEditorBorder")?.resizableImage(withCapInsets: UIEdgeInsets(top: 23.0, left: 23.0, bottom: 23.0, right: 23.0))
        addSubview(imageView)
        
        topLeftCornerView = LSResizeView(frame: .zero)
        topLeftCornerView.delegate = self
        addSubview(topLeftCornerView)
        
        topRightCornerView = LSResizeView(frame: .zero)
        topRightCornerView.delegate = self
        addSubview(topRightCornerView)
        
        bottomLeftCornerView = LSResizeView(frame: .zero)
        bottomLeftCornerView.delegate = self
        addSubview(bottomLeftCornerView)
        
        bottomRightCornerView = LSResizeView(frame: .zero)
        bottomRightCornerView.delegate = self
        addSubview(bottomRightCornerView)
        
        topEdgeView = LSResizeView(frame: .zero)
        topEdgeView.delegate = self
        addSubview(topEdgeView)
        
        leftEdgeView = LSResizeView(frame: .zero)
        leftEdgeView.delegate = self
        addSubview(leftEdgeView)
        
        bottomEdgeView = LSResizeView(frame: .zero)
        bottomEdgeView.delegate = self
        addSubview(bottomEdgeView)
        
        rightEdgeView = LSResizeView(frame: .zero)
        rightEdgeView.delegate = self
        addSubview(rightEdgeView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in subviews {
            if let resizeView = subview as? LSResizeView, resizeView.frame.contains(point) {
                return resizeView
            }
        }
        return nil
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let width = bounds.width
        let height = bounds.height
        
        for i in 0..<3 {
            if showsGridMinor {
                for j in 1..<3 {
                    UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.3).set()
                    
                    UIRectFill(CGRect(x: round(width / 3 / 3 * CGFloat(j) + width / 3 * CGFloat(i)), y: 0.0, width: 1.0, height: round(height)))
                    UIRectFill(CGRect(x: 0.0, y: round(height / 3 / 3 * CGFloat(j) + height / 3 * CGFloat(i)), width: round(width), height: 1.0))
                }
            }
            
            if showsGridMajor && i > 0 {
                UIColor.white.set()
                
                UIRectFill(CGRect(x: round(width / 3 * CGFloat(i)), y: 0.0, width: 1.0, height: round(height)))
                UIRectFill(CGRect(x: 0.0, y: round(height / 3 * CGFloat(i)), width: round(width), height: 1.0))
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topLeftCornerView.frame = CGRect(x: topLeftCornerView.bounds.width / -2, y: topLeftCornerView.bounds.height / -2, width: topLeftCornerView.bounds.width, height: topLeftCornerView.bounds.height)
        topRightCornerView.frame = CGRect(x: bounds.width - topRightCornerView.bounds.width / 2, y: topRightCornerView.bounds.height / -2, width: topRightCornerView.bounds.width, height: topRightCornerView.bounds.height)
        bottomLeftCornerView.frame = CGRect(x: bottomLeftCornerView.bounds.width / -2, y: bounds.height - bottomLeftCornerView.bounds.height / 2, width: bottomLeftCornerView.bounds.width, height: bottomLeftCornerView.bounds.height)
        bottomRightCornerView.frame = CGRect(x: bounds.width - bottomRightCornerView.bounds.width / 2, y: bounds.height - bottomRightCornerView.bounds.height / 2, width: bottomRightCornerView.bounds.width, height: bottomRightCornerView.bounds.height)
        topEdgeView.frame = CGRect(x: max(topLeftCornerView.frame.maxX, 0), y: topEdgeView.bounds.height / -2, width: topRightCornerView.frame.minX - topLeftCornerView.frame.maxX, height: topEdgeView.bounds.height)
        leftEdgeView.frame = CGRect(x: leftEdgeView.bounds.width / -2, y: max(topLeftCornerView.frame.maxY, 0), width: leftEdgeView.bounds.width, height: bottomLeftCornerView.frame.minY - topLeftCornerView.frame.maxY)
        bottomEdgeView.frame = CGRect(x: max(bottomLeftCornerView.frame.maxX, 0), y: bottomLeftCornerView.frame.minY, width: bottomRightCornerView.frame.minX - bottomLeftCornerView.frame.maxX, height: bottomEdgeView.bounds.height)
        rightEdgeView.frame = CGRect(x: bounds.width - rightEdgeView.bounds.width / 2, y: topRightCornerView.frame.maxY, width: rightEdgeView.bounds.width, height: bottomRightCornerView.frame.minY - topRightCornerView.frame.maxY)
    }
    
    func lsOptionalResizeConrolViewDidBeginResizing(_ resizeConrolView: LSResizeView) {
        liveResizing = true
        initialRect = frame
        
        delegate?.lsOptionalCropRectViewDidBeginEditing(self)
        
        if !isRecord && initialRect.width > 0 {
            isRecord = true
            firstRecordRect = initialRect
        }
    }
    
    func lsOptionalResizeConrolViewDidResize(_ resizeConrolView: LSResizeView) {
        frame = cropRectMake(with: resizeConrolView)
        delegate?.lsOptionalCropRectViewEditingChanged(self)
    }
    
    func lsOptionalResizeConrolViewDidEndResizing(_ resizeConrolView: LSResizeView) {
        liveResizing = false
        delegate?.lsOptionalCropRectViewDidEndEditing(self)
    }
    
    func cropRectMake(with resizeControlView: LSResizeView) -> CGRect {
        var rect = frame
        
        if resizeControlView == topEdgeView {
            let width = initialRect.height - resizeControlView.translation.y
            rect = CGRect(x: initialRect.minX + resizeControlView.translation.y / 2,
                          y: initialRect.minY + resizeControlView.translation.y,
                          width: width,
                          height: width)
        } else if resizeControlView == leftEdgeView {
            let width = initialRect.width - resizeControlView.translation.x
            rect = CGRect(x: initialRect.minX + resizeControlView.translation.x,
                          y: initialRect.minY + resizeControlView.translation.x / 2,
                          width: width,
                          height: width)
        } else if resizeControlView == bottomEdgeView {
            let width = initialRect.height + resizeControlView.translation.y
            rect = CGRect(x: initialRect.minX - resizeControlView.translation.y / 2,
                          y: initialRect.minY,
                          width: width,
                          height: width)
        } else if resizeControlView == rightEdgeView {
            let width = initialRect.width + resizeControlView.translation.x
            rect = CGRect(x: initialRect.minX,
                          y: initialRect.minY - resizeControlView.translation.x / 2,
                          width: width,
                          height: width)
        } else if resizeControlView == topLeftCornerView {
            rect = CGRect(x: initialRect.minX + resizeControlView.translation.x,
                          y: initialRect.minY + resizeControlView.translation.x,
                          width: initialRect.width - resizeControlView.translation.x,
                          height: initialRect.height - resizeControlView.translation.x)
        } else if resizeControlView == topRightCornerView {
            rect = CGRect(x: initialRect.minX,
                          y: initialRect.minY + resizeControlView.translation.y,
                          width: initialRect.width - resizeControlView.translation.y,
                          height: initialRect.height - resizeControlView.translation.y)
        } else if resizeControlView == bottomLeftCornerView {
            rect = CGRect(x: initialRect.minX + resizeControlView.translation.x,
                          y: initialRect.minY,
                          width: initialRect.width - resizeControlView.translation.x,
                          height: initialRect.height - resizeControlView.translation.x)
        } else if resizeControlView == bottomRightCornerView {
            rect = CGRect(x: initialRect.minX,
                          y: initialRect.minY,
                          width: initialRect.width + resizeControlView.translation.x,
                          height: initialRect.height + resizeControlView.translation.x)
        }
        
        let minWidth = leftEdgeView.bounds.width + rightEdgeView.bounds.width
        if rect.width < minWidth {
            rect.origin.x = frame.maxX - minWidth
            rect.size.width = minWidth
        }
        
        let minHeight = topEdgeView.bounds.height + bottomEdgeView.bounds.height
        if rect.height < minHeight {
            rect.origin.y = frame.maxY - minHeight
            rect.size.height = minHeight
        }
        
        rect = CGRect(x: max(rect.minX, firstRecordRect.minX),
                      y: max(rect.minY, firstRecordRect.minY),
                      width: min(rect.width, firstRecordRect.width),
                      height: min(rect.height, firstRecordRect.height))
        
        return rect
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
