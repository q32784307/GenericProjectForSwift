//
//  LSBaseTextField.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2024/12/7.
//

import UIKit

class LSBaseTextField: UITextField {
    
    // 输入字数限制
    var maxLength: Int = 0 // 0 表示无限制
    
    // 自定义文本内容显示区域的边距
    var textInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    // 控制光标颜色
    var cursorColor: UIColor? {
        didSet {
            tintColor = cursorColor ?? super.tintColor
        }
    }
    
    // 设置占位符的字体
    var placeholderFont: UIFont? {
        didSet {
            updatePlaceholder()
        }
    }
  
    // 设置占位符的颜色
    var placeholderColor: UIColor? {
        didSet {
            updatePlaceholder()
        }
    }
    
    var textDidChangeHandler: ((_ textStr: String) -> Void)?
    var textSearchReturn: (() -> Void)?
    var textBeginEditing: (() -> Void)?
    
    override var text: String? {
        didSet {
            textDidChange()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc private func textDidChange() {
        if maxLength > 0, let currentText = self.text, currentText.count > maxLength {
            let limitedText = String(currentText.prefix(maxLength))
            self.text = limitedText
        }
        
        if let textDidChangeHandler = textDidChangeHandler {
            textDidChangeHandler(self.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let textSearchReturn = textSearchReturn {
            textSearchReturn()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let textBeginEditing = textBeginEditing {
            textBeginEditing()
        }
    }
    
    // 控制文本显示的区域
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    // 控制编辑时的文本区域
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    // 控制占位符的显示区域
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    // 更新占位符的字体和颜色
    private func updatePlaceholder() {
        guard let placeholderFont = placeholderFont, let placeholderColor = placeholderColor else {
            return
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: placeholderFont,
            .foregroundColor: placeholderColor
        ]
        
        // 设置 attributedPlaceholder
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: attributes)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
