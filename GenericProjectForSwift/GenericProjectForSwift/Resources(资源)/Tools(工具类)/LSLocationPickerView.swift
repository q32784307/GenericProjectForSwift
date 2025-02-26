//
//  LSLocationPickerView.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/16.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class Province: HandyJSON {
    var name: String = ""
    var id: String = ""
    var city: [City] = []

    required init() {}
}

class City: HandyJSON {
    var name: String = ""
    var id: String = ""
    var district: [District] = []

    required init() {}
}

class District: HandyJSON {
    var name: String = ""
    var id: String = ""

    required init() {}
}

class LSLocationPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    var data: [Province] = []
    var selectedProvince: Province?
    var selectedCity: City?
    var selectedDistrict: District?
    
    var didSelectLocation: ((String, String, String, String, String, String) -> Void)?
    
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        containerView.alpha = 0
        return containerView
    }()
    
    private let pickerContainerView: UIView = {
        let pickerContainerView = UIView()
        pickerContainerView.backgroundColor = .white
        return pickerContainerView
    }()

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        dataSource = self
        delegate = self
        
        setupViews()
        setupToolbar()
        loadData()
        
        pickerView(self, didSelectRow: 0, inComponent: 0)
    }
    
    private func setupViews() {
        containerView.frame = UIScreen.main.bounds
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelButtonTapped)))
        
        pickerContainerView.frame = CGRect(x: 0, y: LSScreenHeight, width: LSScreenWidth, height: LSSYRealValue(value: 300))
        self.frame = CGRect(x: 0, y: LSSYRealValue(value: 44), width: LSScreenWidth, height: LSSYRealValue(value: 250))
        pickerContainerView.addSubview(self)
        
        containerView.addSubview(pickerContainerView)
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.addSubview(containerView)
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: LSScreenWidth, height: LSSYRealValue(value: 44)))
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        pickerContainerView.addSubview(toolbar)
        
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
    }
    
    @objc private func cancelButtonTapped() {
        hidePickerView()
    }
    
    @objc private func doneButtonTapped() {
        if let provinceName = selectedProvince?.name, let provinceId = selectedProvince?.id, let cityName = selectedCity?.name, let cityId = selectedCity?.id, let districtName = selectedDistrict?.name, let districtId = selectedDistrict?.id {
            didSelectLocation?(provinceName, provinceId, cityName, cityId, districtName, districtId)
        }
        
        hidePickerView()
    }
    
    private func loadData() {
        if let path = Bundle.main.path(forResource: "城市数据", ofType: "txt") {
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
                let json = JSON(jsonData)
                if let provinceArray = json["province"].arrayObject {
                    if let provinceModels = [Province].deserialize(from: provinceArray) as? [Province] {
                        data = provinceModels
                        reloadAllComponents()
                    } else {
                        print("Failed to parse data")
                    }
                } else {
                    print("Failed to extract province data")
                }
            } else {
                print("Failed to load data from file")
            }
        }
    }

    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return data.count
        } else if component == 1 {
            return selectedProvince?.city.count ?? 0
        } else {
            return selectedCity?.district.count ?? 0
        }
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return data[row].name
        } else if component == 1 {
            return selectedProvince?.city[row].name
        } else {
            return selectedCity?.district[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedProvince = data[row]
            selectedCity = selectedProvince?.city.first
            selectedDistrict = selectedCity?.district.first
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        } else if component == 1 {
            selectedCity = selectedProvince?.city[row]
            selectedDistrict = selectedCity?.district.first
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        } else {
            selectedDistrict = selectedCity?.district[row]
        }
    }
    
    // MARK: - Public Methods
    func showPickerView() {
        containerView.alpha = 0
        pickerContainerView.frame.origin.y = UIScreen.main.bounds.height
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.containerView.alpha = 1
            self?.pickerContainerView.frame.origin.y = LSScreenHeight - LSSYRealValue(value: 300)
        }
    }
    
    func hidePickerView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.containerView.alpha = 0
            self?.pickerContainerView.frame.origin.y = UIScreen.main.bounds.height
        }
    }
}
