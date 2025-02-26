//
//  LSTextView.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/14.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit
import SnapKit

class LSTextView: UIView {
    public let bgView: UIView = UIView()
    var textView: UITextView = UITextView()
    private let placeholderLabel: UILabel = UILabel()
    private let placeholderImageView: UIImageView = UIImageView()
    private let characterCountLabel: UILabel = UILabel()
    
    //设置计数器显示在textView里面还是外面
    public var characterConuntType: Bool = false {
        didSet {
            updateLayout()
        }
    }
    
    //占位文本
    public var placeholderText: String = "请输入文本" {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
    //占位文本是否显示icon
    public var showPlaceholderImageView: Bool = false {
        didSet {
            updatePlaceholderImageViewVisibility()
        }
    }
    
    //设置计数器的数量
    public var maxCharacterCount: Int = 300 {
        didSet {
            updateCharacterCountVisibility()
            updateCharacterCount()
        }
    }
    
    //输入框颜色
    public var textBackgroundColor: UIColor = LSColorUtil.ls_colorWithHexString(color: "F7F6FA", alpha: 1) {
        didSet {
            textView.backgroundColor = textBackgroundColor
        }
    }
    
    //是否显示计数器
    public var showCharacterCount: Bool = true {
        didSet {
            updateCharacterCountVisibility()
        }
    }
    
    //是否显示边框
    public var showLayer: Bool = false {
        didSet {
            updateLayerVisibility()
        }
    }
    
    var textDidChange: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = LSWhiteColor
        
        createSubViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeNotification(_:)), name: UITextView.textDidChangeNotification, object: self.textView)
        
        updatePlaceholderVisibility()
        updateCharacterCountVisibility()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var placeholderFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            placeholderLabel.font = placeholderFont
        }
    }
    
    var placeholderColor: UIColor = UIColor.gray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    var characterCountFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            characterCountLabel.font = characterCountFont
        }
    }
    
    var characterCountColor: UIColor = UIColor.black {
        didSet {
            characterCountLabel.textColor = characterCountColor
        }
    }
    
    var textViewFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            textView.font = textViewFont
        }
    }
    
    func createSubViews() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(0)
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self.snp.right).offset(0)
            make.bottom.equalTo(self.snp.bottom).offset(0)
        }

        textView.backgroundColor = textBackgroundColor
        textView.delegate = self
        bgView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(bgView).offset(0)
            make.left.equalTo(bgView).offset(0)
            make.right.equalTo(bgView.snp.right).offset(0)
            make.bottom.equalTo(bgView.snp.bottom).offset(0)
        }
        
//        placeholderImageView.image = LSImageNamed(name: "树洞_编辑图片")
        textView.addSubview(placeholderImageView)
        placeholderImageView.snp.makeConstraints { make in
            make.top.equalTo(textView).offset(LSSYRealValue(value: 6))
            make.left.equalTo(textView).offset(LSSYRealValue(value: 5))
            make.size.equalTo(CGSizeMake(LSSYRealValue(value: 18), LSSYRealValue(value: 18)))
        }
        
        placeholderLabel.text = placeholderText
        placeholderLabel.font = placeholderFont
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.numberOfLines = 0
        textView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(textView).offset(LSSYRealValue(value: 6))
            make.left.equalTo(textView).offset(LSSYRealValue(value: 5))
        }
        
        characterCountLabel.font = characterCountFont
        characterCountLabel.textColor = characterCountColor
        self.addSubview(characterCountLabel)
        
        updateCharacterCount()
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !textView.text.isEmpty
        if showPlaceholderImageView {
            placeholderImageView.isHidden = !textView.text.isEmpty
        }else{
            placeholderImageView.isHidden = true
        }
    }
    
    private func updateCharacterCountVisibility() {
        characterCountLabel.isHidden = !showCharacterCount
    }
    
    private func updateLayerVisibility() {
        if showLayer {
            bgView.layer.borderWidth = 1
            bgView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    private func updatePlaceholderImageViewVisibility() {
        placeholderImageView.isHidden = !showPlaceholderImageView
        if showPlaceholderImageView {
            placeholderImageView.isHidden = false
            placeholderLabel.snp.remakeConstraints { make in
                make.centerY.equalTo(placeholderImageView.snp.centerY)
                make.left.equalTo(placeholderImageView.snp.right).offset(LSSYRealValue(value: 10))
            }
        }else{
            placeholderImageView.isHidden = true
            placeholderLabel.snp.remakeConstraints { make in
                make.top.equalTo(textView).offset(LSSYRealValue(value: 6))
                make.left.equalTo(textView).offset(LSSYRealValue(value: 5))
            }
        }
    }
    
    private func updateCharacterCount() {
        let currentCount = textView.text.count
        let countText = "\(currentCount)/\(maxCharacterCount)"
        characterCountLabel.text = maxCharacterCount > 0 ? countText : ""
        
        if currentCount > maxCharacterCount {
            characterCountLabel.textColor = UIColor.red
        } else {
            characterCountLabel.textColor = characterCountColor
        }
    }
    
    private func updateLayout() {
        if showCharacterCount {
            if characterConuntType {
                //显示在textView里面
                textView.snp.remakeConstraints { make in
                    make.top.equalTo(bgView).offset(0)
                    make.left.equalTo(bgView).offset(0)
                    make.right.equalTo(bgView.snp.right).offset(0)
                    make.bottom.equalTo(bgView.snp.bottom).offset(0)
                }
                
                characterCountLabel.snp.remakeConstraints { make in
                    make.right.equalTo(textView.snp.right).offset(LSSYRealValue(value: -5))
                    make.bottom.equalTo(textView.snp.bottom).offset(LSSYRealValue(value: -8))
                }
            }else{
                //显示在textView外面
                characterCountLabel.snp.remakeConstraints { make in
                    make.right.equalTo(bgView.snp.right).offset(LSSYRealValue(value: -5))
                    make.bottom.equalTo(bgView.snp.bottom).offset(LSSYRealValue(value: -8))
                }

                textView.snp.remakeConstraints { make in
                    make.top.equalTo(bgView).offset(0)
                    make.left.equalTo(bgView).offset(0)
                    make.right.equalTo(bgView.snp.right).offset(0)
                    make.bottom.equalTo(characterCountLabel.snp.top).offset(0)
                }
            }
        }else{
            characterCountLabel.isHidden = true
            textView.snp.remakeConstraints { make in
                make.top.equalTo(bgView).offset(0)
                make.left.equalTo(bgView).offset(0)
                make.right.equalTo(bgView.snp.right).offset(0)
                make.bottom.equalTo(bgView.snp.bottom).offset(0)
            }
        }
    }
    
    @objc private func textDidChangeNotification(_ notification: Notification) {
        guard let textView = notification.object as? UITextView, textView == self.textView else {
            return
        }
        
        updatePlaceholderVisibility()
        updateCharacterCount()
        textDidChange?(textView.text)
    }
    
    // 外部设置文本内容时调用这个方法，这样placeholderLabel会被正确处理
    func setText(_ text: String) {
        textView.text = text
        updatePlaceholderVisibility()
        updateCharacterCount()
    }
}

extension LSTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if maxCharacterCount > 0 {
            let currentText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            return currentText.count <= maxCharacterCount
        }
        return true
    }
}


