//
//  LSDatePickerUtils.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/15.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit

class LSDatePickerUtils: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    enum DatePickerType {
        case yearMonthDayHourMinute
        case yearMonthDay
        case yearMonth
        case monthDayHourMinute
        case monthDay
        case dayHourMinute
        case hourMinute
    }
    
    private var pickerComponents: [[String]] = []
    private var type: DatePickerType = .yearMonthDayHourMinute
//    var allowPastDates: Bool = true
    private var cancelColor: UIColor = .black
    private var confirmColor: UIColor = .black
    private var headerTitle: String = ""
    private var cellFont: UIFont = UIFont.systemFont(ofSize: 17)
    private var cellTextColor: UIColor = .black
    
    var confirmHandler: ((String) -> Void)?
    
    init(type: DatePickerType, allowPastDates: Bool) {
        super.init(frame: .zero)
        self.type = type
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .white
        
        pickerComponents = createPickerComponents(type: type, allowPastDates: allowPastDates)
        setDefaultDate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDefaultDate() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        var components = DateComponents()
        components.year = calendar.component(.year, from: currentDate)
        components.month = calendar.component(.month, from: currentDate)
        components.day = calendar.component(.day, from: currentDate)
        components.hour = calendar.component(.hour, from: currentDate)
        components.minute = calendar.component(.minute, from: currentDate)
        
        selectDefaultComponents(dateComponents: components)
        
        if let year = components.year, let month = components.month {
            updateDayComponent(year: year, month: month)
        }
    }
    
    private func selectDefaultComponents(dateComponents: DateComponents) {
        var componentIndex = 0
        
        for (index, component) in pickerComponents.enumerated() {
            var selectedIndex = 0
            
            switch index {
            case 0:
                if let year = dateComponents.year, let yearIndex = component.firstIndex(of: "\(year)") {
                    selectedIndex = yearIndex
                }
            case 1:
                if let month = dateComponents.month {
                    selectedIndex = month - 1
                }
            case 2:
                if let day = dateComponents.day {
                    selectedIndex = day - 1
                }
            case 3:
                if let hour = dateComponents.hour {
                    selectedIndex = hour
                }
            case 4:
                if let minute = dateComponents.minute {
                    selectedIndex = minute
                }
            default:
                break
            }
            
            selectRow(selectedIndex, inComponent: componentIndex, animated: false)
            componentIndex += 1
        }
    }
    
    func ls_showPickerInView(_ view: UIView,
                          cancelColor: UIColor = .black,
                          confirmColor: UIColor = .black,
                          headerTitle: String = "",
                          cellFont: UIFont = UIFont.systemFont(ofSize: 17),
                          cellTextColor: UIColor = .black,
                          confirmHandler: ((String) -> Void)?) {
        self.cancelColor = cancelColor
        self.confirmColor = confirmColor
        self.headerTitle = headerTitle
        self.cellFont = cellFont
        self.cellTextColor = cellTextColor
        self.confirmHandler = confirmHandler
        
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let containerView = UIView(frame: keyWindow.bounds)
            containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            let toolBarHeight: CGFloat = 44.0
            let datePickerHeight = frame.height
            let containerHeight = datePickerHeight + toolBarHeight
            
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: toolBarHeight))
            toolBar.barStyle = .default
            toolBar.isTranslucent = true
            
            let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonTapped))
            cancelButton.tintColor = cancelColor
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(doneButtonTapped))
            doneButton.tintColor = confirmColor
            
            toolBar.setItems([cancelButton, flexSpace, doneButton], animated: false)
            
            let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: toolBarHeight))
            headerLabel.textAlignment = .center
            headerLabel.text = headerTitle
            headerLabel.font = UIFont.systemFont(ofSize: 17)
            headerLabel.textColor = .black
            
            let container = UIView(frame: CGRect(x: 0, y: keyWindow.frame.height, width: UIScreen.main.bounds.width, height: containerHeight))
            container.backgroundColor = .white
            container.addSubview(headerLabel)
            container.addSubview(self)
            
            self.frame = CGRect(x: 0, y: toolBarHeight, width: UIScreen.main.bounds.width, height: datePickerHeight)
            
            container.addSubview(toolBar)
            
            containerView.addSubview(container)
            keyWindow.addSubview(containerView)
            
            UIView.animate(withDuration: 0.3) {
                containerView.alpha = 1.0
                container.frame.origin.y = keyWindow.frame.height - containerHeight
            }
        }
    }
    
    @objc private func cancelButtonTapped() {
        hidePickerView()
    }
    
    @objc private func doneButtonTapped() {
        let selectedDate = getSelectedDate()
        let formatter = DateFormatter()
        
        switch type {
        case .yearMonthDayHourMinute:
            formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        case .yearMonthDay:
            formatter.dateFormat = "yyyy年MM月dd日"
        case .yearMonth:
            formatter.dateFormat = "yyyy年MM月"
        case .monthDayHourMinute:
            formatter.dateFormat = "MM月dd日 HH:mm"
        case .monthDay:
            formatter.dateFormat = "MM月dd日"
        case .dayHourMinute:
            formatter.dateFormat = "dd日 HH:mm"
        case .hourMinute:
            formatter.dateFormat = "HH:mm"
        }
        let selectedDateStr = formatter.string(from: selectedDate)
        confirmHandler?(selectedDateStr)
        hidePickerView()
    }
    
    private func hidePickerView() {
        if let containerView = superview?.superview { // Use superview?.superview to access the containerView
            UIView.animate(withDuration: 0.3, animations: {
                containerView.alpha = 0.0
                containerView.subviews.forEach { $0.frame.origin.y = containerView.frame.height } // Move all subviews of containerView off-screen
            }) { _ in
                containerView.removeFromSuperview()
            }
        }
    }
    
    private func getSelectedDate() -> Date {
        var components = DateComponents()
        
        if pickerComponents.count == 5 {
            for (index, component) in pickerComponents.enumerated() {
                let selectedIndex = selectedRow(inComponent: index)
                
                switch index {
                case 0:
                    if let year = Int(component[selectedIndex]) {
                        components.year = year
                    }
                case 1:
                    components.month = selectedIndex + 1
                case 2:
                    components.day = selectedIndex + 1
                case 3:
                    components.hour = selectedIndex
                case 4:
                    components.minute = selectedIndex
                default:
                    break
                }
            }
        }else if pickerComponents.count == 4 {
            for (index, component) in pickerComponents.enumerated() {
                let selectedIndex = selectedRow(inComponent: index)
                
                switch index {
                case 0:
                    if let year = Int(component[selectedIndex]) {
                        components.year = year
                    }
                case 1:
                    components.month = selectedIndex + 1
                case 2:
                    components.day = selectedIndex + 1
                case 3:
                    components.hour = selectedIndex
                default:
                    break
                }
            }
        }else if pickerComponents.count == 3 {
            for (index, component) in pickerComponents.enumerated() {
                let selectedIndex = selectedRow(inComponent: index)
                
                switch index {
                case 0:
                    if let year = Int(component[selectedIndex]) {
                        components.year = year
                    }
                case 1:
                    components.month = selectedIndex + 1
                case 2:
                    components.day = selectedIndex + 1
                default:
                    break
                }
            }
        }else if pickerComponents.count == 2 {
            if type == .hourMinute {
                for (index, component) in pickerComponents.enumerated() {
                    let selectedIndex = selectedRow(inComponent: index)
                    
                    switch index {
                    case 0:
                        components.hour = selectedIndex
                    case 1:
                        components.minute = selectedIndex
                    default:
                        break
                    }
                }
            }
        }
        
        
        let calendar = Calendar.current
        return calendar.date(from: components) ?? Date()
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = pickerComponents[component][row]
        let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: cellTextColor, NSAttributedString.Key.font: cellFont])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedDate = getSelectedDate()
        let calendar = Calendar.current
        let daysRange = calendar.range(of: .day, in: .month, for: selectedDate)!
        let daysInMonth = daysRange.count
        
        if type == .yearMonthDay {
            let currentYear = calendar.component(.year, from: selectedDate)
            let currentMonth = calendar.component(.month, from: selectedDate)
            
            if currentMonth == 2 {
                let isLeapYear = (currentYear % 400 == 0) || ((currentYear % 4 == 0) && (currentYear % 100 != 0))
                let days = isLeapYear ? 29 : 28
                
                if daysInMonth != days {
                    pickerView.reloadComponent(2)
                }
            } else {
                let days = getDaysInMonth(currentMonth)
                
                if daysInMonth != days {
                    pickerView.reloadComponent(2)
                }
            }
        }
        
        if component == 0 || component == 1 {
            let selectedYear = Int(pickerComponents[0][selectedRow(inComponent: 0)]) ?? 0
            let selectedMonth = Int(pickerComponents[1][selectedRow(inComponent: 1)]) ?? 0
            updateDayComponent(year: selectedYear, month: selectedMonth)
        }
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerComponents.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerComponents[component].count
    }
    
    // MARK: - Utility Methods
    
    private func createPickerComponents(type: DatePickerType, allowPastDates: Bool) -> [[String]] {
        var components: [[String]] = []
        
        switch type {
        case .yearMonthDayHourMinute:
            let years = createYearRange(allowPastDates: allowPastDates)
            let months = createMonthRange()
            let days = createDayRange()
            let hours = createHourRange()
            let minutes = createMinuteRange()
            
            components.append(years)
            components.append(months)
            components.append(days)
            components.append(hours)
            components.append(minutes)
        case .yearMonthDay:
            let years = createYearRange(allowPastDates: allowPastDates)
            let months = createMonthRange()
            let days = createDayRange()
            
            components.append(years)
            components.append(months)
            components.append(days)
        case .yearMonth:
            let years = createYearRange(allowPastDates: allowPastDates)
            let months = createMonthRange()
            
            components.append(years)
            components.append(months)
        case .monthDayHourMinute:
            let months = createMonthRange()
            let days = createDayRange()
            let hours = createHourRange()
            let minutes = createMinuteRange()
            
            components.append(months)
            components.append(days)
            components.append(hours)
            components.append(minutes)
        case .monthDay:
            let months = createMonthRange()
            let days = createDayRange()
            
            components.append(months)
            components.append(days)
        case .dayHourMinute:
            let days = createDayRange()
            let hours = createHourRange()
            let minutes = createMinuteRange()
            
            components.append(days)
            components.append(hours)
            components.append(minutes)
        case .hourMinute:
            let hours = createHourRange()
            let minutes = createMinuteRange()
            
            components.append(hours)
            components.append(minutes)
        }
        
        return components
    }
    
    private func createYearRange(allowPastDates: Bool) -> [String] {
        let currentDate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        var range = year - 100 ... year + 100
        if allowPastDates {
            range = year - 100 ... year + 100
        }else{
            range = year ... year + 100
        }
        return range.map { "\($0)" }
    }
    
    private func createMonthRange() -> [String] {
        return (1...12).map { String(format: "%02d", $0) }
    }
    
    private func createDayRange() -> [String] {
        return (1...31).map { String(format: "%02d", $0) }
    }
    
    private func createHourRange() -> [String] {
        return (0...23).map { String(format: "%02d", $0) }
    }
    
    private func createMinuteRange() -> [String] {
        return (0...59).map { String(format: "%02d", $0) }
    }
    
    private func createDayRange(days: Int) -> [String] {
        return (1...days).map { String(format: "%02d", $0) }
    }
    
    private func getDaysInMonth(_ month: Int) -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        
        var components = DateComponents()
        components.year = calendar.component(.year, from: currentDate)
        components.month = month
        
        if let date = calendar.date(from: components), let daysInMonth = calendar.range(of: .day, in: .month, for: date)?.count {
            return daysInMonth
        }
        
        return 0
    }
    
    private func updateDayComponent(year: Int, month: Int) {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month)
        guard let selectedDate = calendar.date(from: components) else { return }
        let daysRange = calendar.range(of: .day, in: .month, for: selectedDate)!
        let daysInMonth = daysRange.count
        
        if pickerComponents.count > 2 {
            pickerComponents[2] = createDayRange(days: daysInMonth)
            reloadComponent(2)
            
            let selectedDay = selectedRow(inComponent: 2)
            if selectedDay >= daysInMonth {
                selectRow(daysInMonth - 1, inComponent: 2, animated: false)
            }
        }
    }
}

