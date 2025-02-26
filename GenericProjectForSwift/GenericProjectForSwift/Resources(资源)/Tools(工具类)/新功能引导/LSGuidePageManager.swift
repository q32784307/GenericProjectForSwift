//
//  LSGuidePageManager.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/7/7.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//
/**
 使用方法
 LSGuidePageManager.shared.showGuidePage(type: .home) {
     LSGuidePageManager.shared.showGuidePage(type: .major) {
         LSGuidePageManager.shared.showGuidePage(type: .home) {
             
         }
     }
 }
 */


import UIKit

let LSGuidePageHomeKey = "LSGuidePageHomeKey"
let LSGuidePageMajorKey = "LSGuidePageMajorKey"

let KMainW = UIScreen.main.bounds.size.width
let KMainH = UIScreen.main.bounds.size.height

let KScreenRate = (375 / KMainW)
func KSuitFloat(_ float: CGFloat) -> CGFloat { return float / KScreenRate }
func KSuitPoint(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x / KScreenRate, y: y / KScreenRate) }
func KSuitRect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect { return CGRect(x: x / KScreenRate, y: y / KScreenRate, width: width / KScreenRate, height: height / KScreenRate) }

typealias FinishBlock = () -> Void

enum LSGuidePageType: Int {
    case home = 0
    case major
}

class LSGuidePageManager {
    static let shared = LSGuidePageManager()
        
    private var finish: FinishBlock?
    private var guidePageKey: String?
    private var guidePageType: LSGuidePageType?
    
    func showGuidePage(type: LSGuidePageType) {
        creatControl(type: type, completion: nil)
    }
    
    func showGuidePage(type: LSGuidePageType, completion: @escaping FinishBlock) {
        creatControl(type: type, completion: completion)
    }
    
    private func creatControl(type: LSGuidePageType, completion: FinishBlock?) {
        finish = completion
        
        let frame = UIScreen.main.bounds
        let bgView = UIView(frame: frame)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        let imgView = UIImageView()
        bgView.addSubview(imgView)
        
        let path = UIBezierPath(rect: frame)
        switch type {
        case .home:
            //圆
//            path.append(UIBezierPath(arcCenter: KSuitPoint(227, 188), radius: KSuitFloat(46), startAngle: 0, endAngle: 2 * .pi, clockwise: false))
            //方块
            path.append(UIBezierPath(roundedRect: KSuitRect(227, 188, 90, 40), cornerRadius: 5).reversing())
            imgView.frame = KSuitRect(220, 40, 100, 100)
            imgView.image = UIImage(named: "")
            guidePageKey = LSGuidePageHomeKey
            
        case .major:
            path.append(UIBezierPath(roundedRect: KSuitRect(5, 436, 90, 40), cornerRadius: 5).reversing())
            imgView.frame = KSuitRect(100, 320, 120, 120)
            imgView.image = UIImage(named: "")
            guidePageKey = LSGuidePageMajorKey
            
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        bgView.layer.mask = shapeLayer
    }
    
    @objc private func tap(_ recognizer: UITapGestureRecognizer) {
        if let bgView = recognizer.view {
            bgView.removeFromSuperview()
            bgView.removeGestureRecognizer(recognizer)
            bgView.subviews.forEach({ $0.removeFromSuperview() })
            guidePageKey.flatMap({ UserDefaults.standard.set(true, forKey: $0) })
            
            finish?()
        }
    }
}
