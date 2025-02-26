//
//  LSCustomPickerView.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/7/13.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit

class LSCustomPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // UIPickerView 数据源和委托
    var pickerView: UIPickerView!
    var toolbar: UIToolbar!
    var dataSource: [[String]] = []
    
    // 回调闭包
    var selectionHandler: (([String], _ indexSelect: Int) -> Void)?

    
    // 初始化方法
    init(frame: CGRect, dataSource: [[String]]) {
        super.init(frame: frame)
        self.dataSource = dataSource
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置界面
    private func setupUI() {
        // 添加遮罩层
        let maskView = UIView(frame: LSScreenBounds)
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(maskView)
        
        // 添加 UIPickerView
        pickerView = UIPickerView(frame: CGRect(x: 0, y: LSScreenHeight - LSSYRealValue(value: 200), width: LSScreenWidth, height: LSSYRealValue(value: 200)))
        pickerView.backgroundColor = LSWhiteColor
        pickerView.delegate = self
        pickerView.dataSource = self
        maskView.addSubview(pickerView)
        
        // 添加工具栏
        toolbar = UIToolbar(frame: CGRect(x: 0, y: LSScreenHeight - LSSYRealValue(value: 240), width: LSScreenWidth, height: LSSYRealValue(value: 40)))
        toolbar.barStyle = .default
        
        // 添加取消按钮
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        // 添加确定按钮
        let doneButton = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(doneButtonTapped))

        // 添加弹簧按钮，用于标题居中
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // 添加标题
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: LSScreenWidth - LSSYRealValue(value: 140), height: LSSYRealValue(value: 40)))
        titleLabel.textAlignment = .center
        titleLabel.font = LSFontRegular(FONTSIZE: LSSYRealValue(value: 14))
        titleLabel.text = "选择"
        let titleButton = UIBarButtonItem(customView: titleLabel)
        
        // 设置工具栏按钮
        toolbar.setItems([flexibleSpace, cancelButton, flexibleSpace, titleButton, flexibleSpace, doneButton, flexibleSpace], animated: false)
        maskView.addSubview(toolbar)
    }
    
    // MARK: - Button Actions
    @objc private func cancelButtonTapped() {
        hidePickerView()
    }
    
    @objc private func doneButtonTapped() {
        var selectedValues: [String] = []
        var selectedPath: Int = 0
        for component in 0..<pickerView.numberOfComponents {
            let selectedRow = pickerView.selectedRow(inComponent: component)
            let componentData = dataSource[component]
            if selectedRow >= 0 && selectedRow < componentData.count {
                selectedValues.append(componentData[selectedRow])
            }
            
            selectedPath = selectedRow
        }
        selectionHandler?(selectedValues, selectedPath)
        hidePickerView()
    }
    
    // MARK: - UIPickerView Delegate and DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataSource.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard component < dataSource.count else {
            return 0
        }
        return dataSource[component].count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard component < dataSource.count && row < dataSource[component].count else {
            return nil
        }
        return dataSource[component][row]
    }

    // MARK: - Show and Hide
    func showPickerView() {
        UIView.animate(withDuration: 0.3, animations: { [self] in
            pickerView.frame.origin.y = LSScreenHeight - LSSYRealValue(value: 200)
            toolbar.frame.origin.y = LSScreenHeight - LSSYRealValue(value: 240)
        }) { _ in
            
        }
    }
    
    func hidePickerView() {
        UIView.animate(withDuration: 0.3, animations: { [self] in
            pickerView.frame.origin.y = LSScreenHeight
            toolbar.frame.origin.y = LSScreenHeight
        }) { _ in
            self.removeFromSuperview()
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
