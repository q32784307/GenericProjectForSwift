//
//  LSAndroidForActionSheet.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/7/13.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit

class LSAndroidForActionSheet: UIView {
    private var backgroundView: UIView!
    var clickHandler: ((Int) -> Void)?
    
    init(frame: CGRect, titleArr: [String]) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hiddenSheet))
        addGestureRecognizer(tapGesture)
        makeBaseUIWithTitleArr(titleArr: titleArr)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeBaseUIWithTitleArr(titleArr: [String]) {
        backgroundView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: CGFloat(titleArr.count) * LSSYRealValue(value: 50) + LSSYRealValue(value: 55) + LSSafeDistanceBottom()))
        backgroundView.backgroundColor = .white
        self.addSubview(backgroundView)
        
        var y = createButton(withTitle: "取消", originY: backgroundView.frame.size.height - LSSYRealValue(value: 45) - LSSafeDistanceBottom(), tag: -1, action: #selector(hiddenSheet)) - LSSYRealValue(value: 60)
        
        let lineView = UIView(frame: CGRect(x: 0, y: CGFloat(titleArr.count) * LSSYRealValue(value: 50), width: LSScreenWidth, height: LSSYRealValue(value: 10)))
        lineView.backgroundColor = UIColor(red: 0xe9/255.0, green: 0xe9/255.0, blue: 0xe9/255.0, alpha: 1.0)
        backgroundView.addSubview(lineView)
        
        for (index, title) in titleArr.enumerated() {
            y = createButton(withTitle: title, originY: y, tag: index, action: #selector(click(_:)))
            
            let lineView1 = UIView(frame: CGRect(x: 0, y: CGFloat(index + 1) * LSSYRealValue(value: 50), width: LSScreenWidth, height: 1))
            lineView1.backgroundColor = UIColor(red: 0xe9/255.0, green: 0xe9/255.0, blue: 0xe9/255.0, alpha: 1.0)
            backgroundView.addSubview(lineView1)
            
            if index == titleArr.count - 1 {
                lineView1.isHidden = true
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            var frame = self.backgroundView.frame
            frame.origin.y -= frame.size.height
            self.backgroundView.frame = frame
        }
    }
    
    private func createButton(withTitle title: String, originY y: CGFloat, tag: Int, action method: Selector) -> CGFloat {
        let actionSheetButton = UIButton(type: .custom)
        actionSheetButton.setTitle(title, for: .normal)
        actionSheetButton.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.size.width, height: LSSYRealValue(value: 50))
        actionSheetButton.tag = tag
        actionSheetButton.titleLabel?.font = UIFont.systemFont(ofSize: LSSYRealValue(value: 15))
        actionSheetButton.setTitleColor(.black, for: .normal)
        actionSheetButton.addTarget(self, action: method, for: .touchUpInside)
        backgroundView.addSubview(actionSheetButton)
        
        return y - (tag == -1 ? 0 : LSSYRealValue(value: 50))
    }
    
    @objc private func hiddenSheet() {
        UIView.animate(withDuration: 0.3) {
            var frame = self.backgroundView.frame
            frame.origin.y += frame.size.height
            self.backgroundView.frame = frame
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.removeFromSuperview()
        }
    }
    
    @objc private func click(_ btn: UIButton) {
        clickHandler?(btn.tag)
        hiddenSheet()
    }
}
