//
//  LSCropView.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/7/13.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit
import AVFoundation

protocol LSCropViewDelegate: AnyObject {
    func lsOptionalDidBeginingTailor(_ cropView: LSCropView)
    func lsOptionalDidFinishTailor(_ cropView: LSCropView)
}

class LSCropView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate, LSCropRectViewDelegate {
    weak var delegate: LSCropViewDelegate?
    var scrollView: UIScrollView!
    var zoomingView: UIView!
    var imageView: UIImageView!
    var cropRectView: LSCropRectView!
    var topOverlayView: UIView!
    var leftOverlayView: UIView!
    var rightOverlayView: UIView!
    var bottomOverlayView: UIView!
    var insetRect: CGRect = .zero
    var editingRect: CGRect = .zero
    var resizing: Bool = false
    var isZoom: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .clear
        
        scrollView = UIScrollView(frame: bounds)
        scrollView.delegate = self
        scrollView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        scrollView.backgroundColor = .clear
        scrollView.maximumZoomScale = 20.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.bouncesZoom = false
        scrollView.clipsToBounds = false
        addSubview(scrollView)
        
        cropRectView = LSCropRectView()
        cropRectView.delegate = self
        addSubview(cropRectView)
        
        topOverlayView = UIView()
        topOverlayView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        addSubview(topOverlayView)
        
        leftOverlayView = UIView()
        leftOverlayView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        addSubview(leftOverlayView)
        
        rightOverlayView = UIView()
        rightOverlayView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        addSubview(rightOverlayView)
        
        bottomOverlayView = UIView()
        bottomOverlayView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        addSubview(bottomOverlayView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if image == nil {
            return
        }
        
        editingRect = bounds.insetBy(dx: MarginLeft, dy: MarginTop)
        
        if imageView == nil {
            insetRect = bounds.insetBy(dx: MarginLeft, dy: MarginTop)
            setupImageView()
        }
        
        if !resizing {
            layoutCropRectView(with: scrollView.frame)
        }
    }
    
    func layoutCropRectView(with cropRect: CGRect) {
        cropRectView.frame = cropRect
        let width = cropRect.size.width
        let height = cropRect.size.height
        let rect = CGRect(x: cropRect.minX,
                          y: cropRect.minY + (height - width)/2,
                          width: width,
                          height: width)
        UIView.animate(withDuration: 1.0) {
            self.cropRectView.frame = rect
        }
        layoutOverlayViewsWithCropRect(cropRect)
    }
    
    func layoutOverlayViewsWithCropRect(_ cropRect: CGRect) {
        topOverlayView.frame = CGRect(x: 0.0,
                                      y: 0.0,
                                      width: bounds.width,
                                      height: cropRect.minY)
        leftOverlayView.frame = CGRect(x: 0.0,
                                       y: cropRect.minY,
                                       width: cropRect.minX,
                                       height: cropRect.height)
        rightOverlayView.frame = CGRect(x: cropRect.maxX,
                                        y: cropRect.minY,
                                        width: bounds.width - cropRect.maxX,
                                        height: cropRect.height)
        bottomOverlayView.frame = CGRect(x: 0.0,
                                         y: cropRect.maxY,
                                         width: bounds.width,
                                         height: bounds.height - cropRect.maxY)
    }
    
    func setupImageView() {
        var cropRect = AVMakeRect(aspectRatio: image!.size, insideRect: insetRect)
        
        scrollView.frame = cropRect
        scrollView.contentSize = cropRect.size
        
        zoomingView = UIView(frame: scrollView.bounds)
        zoomingView.backgroundColor = .clear
        scrollView.addSubview(zoomingView)
        
        imageView = UIImageView(frame: zoomingView.bounds)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        zoomingView.addSubview(imageView)
    }
    
    var image: UIImage? {
        didSet {
            imageView?.removeFromSuperview()
            imageView = nil
            
            zoomingView?.removeFromSuperview()
            zoomingView = nil
            
            setNeedsLayout()
        }
    }
    
    var aspectRatio: CGFloat {
        get {
            let cropRect = scrollView.frame
            let width = cropRect.width
            let height = cropRect.height
            return width / height
        }
        set {
            var cropRect = scrollView.frame
            var width = cropRect.width
            var height = cropRect.height
            if width < height {
                width = height * newValue
            } else {
                height = width * newValue
            }
            cropRect.size = CGSize(width: width, height: height)
            zoomToCropRect(cropRect)
        }
    }
    
    var cropRect: CGRect {
        get {
            return scrollView.frame
        }
        set {
            zoomToCropRect(newValue)
        }
    }
    
    var croppedImage: UIImage? {
        if let image = image {
            delegate?.lsOptionalDidBeginingTailor(self)
            
            var cropRect = convert(scrollView.frame, to: zoomingView)
            let size = image.size
            
            if !isZoom {
                cropRect = CGRect(x: cropRect.origin.x, y: cropRect.origin.y, width: cropRect.size.width, height: cropRect.size.width)
            }
            
            var ratio: CGFloat = 1.0
            let orientation = UIApplication.shared.statusBarOrientation
            if UIDevice.current.userInterfaceIdiom == .pad || orientation.isPortrait {
                ratio = AVMakeRect(aspectRatio: image.size, insideRect: insetRect).width / size.width
            } else {
                ratio = AVMakeRect(aspectRatio: image.size, insideRect: insetRect).height / size.height
            }
            
            let zoomedCropRect = CGRect(x: cropRect.origin.x / ratio,
                                        y: cropRect.origin.y / ratio,
                                        width: cropRect.size.width / ratio,
                                        height: cropRect.size.height / ratio)
            
            let rotatedImage = rotatedImage(with: image, transform: imageView.transform)
            
            if let croppedImage = rotatedImage.cgImage?.cropping(to: zoomedCropRect) {
                let image = UIImage(cgImage: croppedImage, scale: 1.0, orientation: rotatedImage.imageOrientation)
                
                delegate?.lsOptionalDidFinishTailor(self)
                
                return image
            }
        }
        
        return nil
    }
    
    func rotatedImage(with image: UIImage, transform: CGAffineTransform) -> UIImage {
        let size = image.size
        
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: size.width / 2, y: size.height / 2)
            context.concatenate(transform)
            context.translateBy(x: -size.width / 2, y: -size.height / 2)
            image.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        }
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage ?? image
    }
    
    func cappedCropRectInImageRect(with cropRectView: LSCropRectView) -> CGRect {
        var cropRect = cropRectView.frame
        
        let rect = convert(cropRect, to: scrollView)
        if rect.minX < zoomingView.frame.minX {
            cropRect.origin.x = scrollView.convert(zoomingView.frame, to: self).minX
            cropRect.size.width = rect.maxX
        }
        if rect.minY < zoomingView.frame.minY {
            cropRect.origin.y = scrollView.convert(zoomingView.frame, to: self).minY
            cropRect.size.height = rect.maxY
        }
        if rect.maxX > zoomingView.frame.maxX {
            cropRect.size.width = scrollView.convert(zoomingView.frame, to: self).maxX - cropRect.minX
        }
        if rect.maxY > zoomingView.frame.maxY {
            cropRect.size.height = scrollView.convert(zoomingView.frame, to: self).maxY - cropRect.minY
        }
        
        return cropRect
    }
    
    func automaticZoomIfEdgeTouched(_ cropRect: CGRect) {
        let editingRectExtended = editingRect.insetBy(dx: -5.0, dy: -5.0)
        if !editingRectExtended.contains(cropRect) {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .beginFromCurrentState) {
                self.zoomToCropRect(self.cropRectView.frame)
            }
        }
    }
    
    func lsOptionalCropRectViewDidBeginEditing(_ cropRectView: LSCropRectView) {
        resizing = true
        isZoom = true
    }
    
    func lsOptionalCropRectViewEditingChanged(_ cropRectView: LSCropRectView) {
        let cropRect = cappedCropRectInImageRect(with: cropRectView)
        layoutCropRectView(with: cropRect)
        automaticZoomIfEdgeTouched(cropRect)
    }
    
    func lsOptionalCropRectViewDidEndEditing(_ cropRectView: LSCropRectView) {
        resizing = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if !self.resizing {
                self.zoomToCropRect(self.cropRectView.frame)
            }
        }
    }
    
    func zoomToCropRect(_ toRect: CGRect) {
        if scrollView.frame == toRect {
            return
        }
        
        let width = toRect.width
        let height = toRect.height
        
        let scale = min(editingRect.width / width, editingRect.height / height)
        
        let scaledWidth = width * scale
        let scaledHeight = height * scale
        let cropRect = CGRect(x: (bounds.width - scaledWidth) / 2,
                              y: (bounds.height - scaledHeight) / 2,
                              width: scaledWidth,
                              height: scaledHeight)
        
        var zoomRect = convert(toRect, to: zoomingView)
        zoomRect.size.width = cropRect.width / (scrollView.zoomScale * scale)
        zoomRect.size.height = cropRect.height / (scrollView.zoomScale * scale)
        
        UIView.animate(withDuration: 0.25) {
            self.scrollView.bounds = cropRect
            self.scrollView.zoom(to: zoomRect, animated: false)
            self.layoutCropRectView(with: cropRect)
        }
    }
    
    // Gesture Recognizer Delegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // Scroll View Delegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomingView
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
    }
    
    // Hit Test
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = cropRectView.hitTest(convert(point, to: cropRectView), with: event)
        if hitView != nil {
            return hitView
        }
        let locationInImageView = convert(point, to: zoomingView)
        let zoomedPoint = CGPoint(x: locationInImageView.x * scrollView.zoomScale, y: locationInImageView.y * scrollView.zoomScale)
        if zoomingView.frame.contains(zoomedPoint) {
            return scrollView
        }
        
        return super.hitTest(point, with: event)
    }
    
    // Constants
    
    private let MarginTop: CGFloat = 37.0
    private let MarginLeft: CGFloat = 20.0

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
