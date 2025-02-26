//
//  LSDateTransformationManager.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/1.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//
//  时间获取与格式转换

import Foundation

class LSDateTransformationManager {
    static let shared = LSDateTransformationManager()
    
    private init() {}
    
    // 获取当前时间
    func ls_getCurrentDateString(withDateFormat dateFormat: String) -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = dateFormat
        let dateString = dateFormatter.string(from: currentDate)
        
        return dateString
    }
    
    // 获取当前时间戳
    func ls_getCurrentTimeString() -> String {
        let date = Date()
        let time = date.timeIntervalSince1970 * 1000
        let timeString = String(format: "%.0f", time)
        
        return timeString
    }
    
    // 时间字符串转化成字符串型时间戳
    func ls_stringToTime(withDateFormat dateFormat: String, timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "Asia/Shanghai")
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        if let date = dateFormatter.date(from: timeString) {
            let timeSp = String(format: "%ld", Int(date.timeIntervalSince1970))
            return timeSp
        }
        return nil
    }
    
    // 字符串型时间戳转化时间字符串
    func ls_timeToString(withDateFormat dateFormat: String, timeString: String) -> String? {
        if let tempTime = TimeInterval(timeString) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            dateFormatter.timeZone = TimeZone(abbreviation: "Asia/Shanghai")
            dateFormatter.locale = Locale.current
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            let confromTimesp = Date(timeIntervalSince1970: tempTime)
            dateFormatter.dateFormat = dateFormat
            let confromTimespStr = dateFormatter.string(from: confromTimesp)
            
            return confromTimespStr
        }
        return nil
    }
    
    // Date转化为字符串
    func ls_dateToString(withDateFormat dateFormat: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "Asia/Shanghai")
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        let timeString = dateFormatter.string(from: date)
        
        return timeString
    }
    
    // 字符串转化为Date
    func ls_stringToDate(withDateFormat dateFormat: String, dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "Asia/Shanghai")
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        let timeDate = dateFormatter.date(from: dateString)
        
        return timeDate
    }
    
    // 根据两个Date类型时间，计算差值
    func ls_numberOfDays(withDateFormat dateFormat: String, startDate: String, endDate: String) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = dateFormat
        if let startTime = dateFormatter.date(from: startDate), let endTime = dateFormatter.date(from: endDate) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startTime, to: endTime)
            let numberOfDays = [
                "\(components.year ?? 0)",
                "\(components.month ?? 0)",
                "\(components.day ?? 0)",
                "\(components.hour ?? 0)",
                "\(components.minute ?? 0)",
                "\(components.second ?? 0)"
            ]
            return numberOfDays
        }
        return []
    }
    
    // 根据两个字符串类型时间，计算差值（输出天）
    func ls_calculateTimeDifferenceInDays(from startDate: Date, to endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        if let days = components.day {
            return Int(days)
        } else {
            return 0
        }
    }
    
    // 判断是否为今天
    func ls_isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())

        return components.year == todayComponents.year && components.month == todayComponents.month && components.day == todayComponents.day
    }
    
    /**********************处理时间显示**********************/
    func ls_compareCurrentTime(_ str: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let timeDate = dateFormatter.date(from: str) else {
            return ""
        }
        
        let currentDate = Date()
        let timeInterval = currentDate.timeIntervalSince(timeDate)
        var result: String = ""
        
        if timeInterval / 60 < 1 {
            result = "刚刚"
        } else if (timeInterval / 60) < 60 {
            result = "\(Int(timeInterval / 60))分钟前"
        } else if (timeInterval / 60 / 60) < 24 {
            result = "\(Int(timeInterval / 60 / 60))小时前"
        } else if (timeInterval / 60 / 60 / 24) < 30 {
            result = "\(Int(timeInterval / 60 / 60 / 24))天前"
        } else if (timeInterval / 60 / 60 / 24 / 30) < 12 {
            result = "\(Int(timeInterval / 60 / 60 / 24 / 30))月前"
        } else {
            result = "\(Int(timeInterval / 60 / 60 / 24 / 30 / 12))年前"
        }
        
        return result
    }
    /********************************************/
    
}
