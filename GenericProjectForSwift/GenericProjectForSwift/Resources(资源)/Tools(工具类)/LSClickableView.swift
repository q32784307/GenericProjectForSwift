//
//  LSClickableView.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/30.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//
/**
 let clickableLabel = LSClickableView()
 clickableLabel.setText("我已同意《微留用户协议》和《微留隐私政策》")
 clickableLabel.setHighlightedColor(LSColorUtil.ls_colorWithHexString(color: "81DFF9", alpha: 1))
 clickableLabel.setChecked(true)
 clickableLabel.setFont(LSFontRegular(FONTSIZE: LSSYRealValue(value1: 12, value2: 12)))
 self.addSubview(clickableLabel)
 clickableLabel.snp.makeConstraints { make in
     make.top.equalTo(passwordTextField.snp.bottom).offset(LSSYRealValue(value1: 18, value2: 18))
     make.centerX.equalTo(self.snp.centerX)
 }
 clickableLabel.addClickAction(toSubstring: "《微留用户协议》") { [self] in
    
 }
 clickableLabel.addClickAction(toSubstring: "《微留隐私政策》") { [self] in
    
 }
 clickableLabel.onCheckboxToggle = { [self] isChecked in
     
 }
 */

import UIKit

class LSClickableView: UIView {
    
    typealias ClickAction = () -> Void

    private var clickActions: [(NSRange, ClickAction)] = []
    private var highlightedColor: UIColor?
    private var checkboxButton: UIButton!
    private var label: UILabel!
    var onCheckboxToggle: ((Bool) -> Void)?

    init() {
        super.init(frame: .zero)
        setupUI()
        setupGestureRecognizer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupGestureRecognizer()
    }

    private func setupUI() {
        checkboxButton = UIButton()
        checkboxButton.setImage(UIImage(named: "登录_协议未选中"), for: .normal)
        checkboxButton.setImage(UIImage(named: "登录_协议选中"), for: .selected)
        addSubview(checkboxButton)

        label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        addSubview(label)

        checkboxButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(LSSYRealValue(value: 16))
            make.height.equalTo(LSSYRealValue(value: 16))
        }

        label.snp.makeConstraints { make in
            make.left.equalTo(checkboxButton.snp.right).offset(LSSYRealValue(value: 6))
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        checkboxButton.addTarget(self, action: #selector(checkboxButtonTapped), for: .touchUpInside)
    }

    private func setupGestureRecognizer() {
        isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func viewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let attributedText = label.attributedText else { return }

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: bounds.size)
        let textStorage = NSTextStorage(attributedString: attributedText)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let locationOfTouchInLabel = gestureRecognizer.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let textContainerOffset = CGPoint(x: (bounds.width - textBoundingBox.width) * 0.5 - textBoundingBox.minX,
                                          y: (bounds.height - textBoundingBox.height) * 0.5 - textBoundingBox.minY)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)

        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                            in: textContainer,
                                                            fractionOfDistanceBetweenInsertionPoints: nil)

        for (range, action) in clickActions {
            if NSLocationInRange(indexOfCharacter, range) {
                action()
                return
            }
        }
    }

    @objc private func checkboxButtonTapped() {
        checkboxButton.isSelected.toggle()
        onCheckboxToggle?(checkboxButton.isSelected)
    }

    func setText(_ text: String) {
        label.text = text
    }
    
    func setFont(_ font: UIFont) {
        label.font = font
    }

    func setAttributedText(_ attributedText: NSAttributedString) {
        label.attributedText = attributedText
    }
    
    func addClickAction(toSubstring substring: String, action: @escaping ClickAction) {
        guard let attributedText = label.attributedText, let labelText = label.text else { return }

        if let range = labelText.range(of: substring) {
            let nsRange = NSRange(range, in: labelText)
            clickActions.append((nsRange, action))

            let attributedString = NSMutableAttributedString(attributedString: attributedText)
            attributedString.removeAttribute(.underlineStyle, range: nsRange)

            if let highlightedColor = highlightedColor {
                attributedString.addAttribute(.foregroundColor, value: highlightedColor, range: nsRange)
            }

            label.attributedText = attributedString
        }
    }

    func setHighlightedColor(_ color: UIColor) {
        highlightedColor = color

        if let attributedText = label.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: attributedText)

            for (range, _) in clickActions {
                attributedString.addAttribute(.foregroundColor, value: color, range: range)
            }

            label.attributedText = attributedString
        }
    }

    func isChecked() -> Bool {
        return checkboxButton.isSelected
    }

    func setChecked(_ checked: Bool) {
        checkboxButton.isSelected = checked
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
