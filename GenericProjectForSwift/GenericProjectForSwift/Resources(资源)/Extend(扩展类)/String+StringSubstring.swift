//
//  String+StringSubstring.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/8/17.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import Foundation

extension String {
    //从指定索引开始截取到字符串末尾
    func ls_substring(from index: Int) -> String {
        guard index >= 0 && index < self.count else {
            return ""
        }
        let startIndex = self.index(self.startIndex, offsetBy: index)
        return String(self[startIndex...])
    }
    
    //从字符串开头截取到指定索引
    func ls_substring(to index: Int) -> String {
        guard index >= 0 && index < self.count else {
            return ""
        }
        let endIndex = self.index(self.startIndex, offsetBy: index)
        return String(self[..<endIndex])
    }
    
    //在给定范围内截取子字符串
    func ls_substring(with range: Range<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        return String(self[start..<end])
    }
    
    //指定位置开始的指定长度的子字符串
    func ls_substring(from index: Int, length: Int) -> String {
        guard index >= 0 && index < self.count && length > 0 else {
            return ""
        }
        let startIndex = self.index(self.startIndex, offsetBy: index)
        let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
        return String(self[startIndex..<endIndex])
    }
    
    //手机号中间4位替换*
    func ls_maskPhoneNumber() -> String {
        // 正则表达式匹配手机号码的中间四位
        let regex = try! NSRegularExpression(pattern: "(\\d{3})(\\d{4})(\\d{4})", options: [])
        
        // 使用替换模式
        let range = NSRange(location: 0, length: self.utf16.count)
        let maskedPhoneNumber = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1****$3")
        
        return maskedPhoneNumber
    }
    
    //银行卡号添加空格分隔
    func ls_formatAsBankCardNumber() -> String {
        // 去掉所有空格
        let cardNumberWithoutSpaces = self.replacingOccurrences(of: " ", with: "")
        
        var formattedCardNumber = ""
        
        // 遍历银行卡号的每一位，添加空格
        for (index, character) in cardNumberWithoutSpaces.enumerated() {
            if index > 0 && index % 4 == 0 {
                formattedCardNumber.append(" ")
            }
            formattedCardNumber.append(character)
        }
        
        return formattedCardNumber
    }
}

//let originalString = "Hello, World!"
//
//let substring1 = originalString.ls_substring(from: 7) // "World!"
//let substring2 = originalString.ls_substring(to: 5)   // "Hello"
//let substring3 = originalString.ls_substring(with: 7..<12) // "World"
//let substring4 = originalString.ls_ubstring(from: 7, length: 3) // "Wor"
//
//print(substring1)
//print(substring2)
//print(substring3)
//print(substring4)
