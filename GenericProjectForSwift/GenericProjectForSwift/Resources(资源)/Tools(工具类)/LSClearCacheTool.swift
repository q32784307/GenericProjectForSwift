//
//  LSClearCacheTool.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/1.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//
//  清理缓存

import Foundation

class LSClearCacheTool {
    // 获取path路径下文件夹的缓存大小
    class func ls_getCacheSize(withFilePath path: String) -> String {
        let fileManager = FileManager.default
        var totleSize: Int64 = 0

        guard let subPathArr = fileManager.subpaths(atPath: path) else {
            return ""
        }

        for subPath in subPathArr {
            let filePath = (path as NSString).appendingPathComponent(subPath)
            var isDirectory: ObjCBool = false
            let isExist = fileManager.fileExists(atPath: filePath, isDirectory: &isDirectory)

            if !isExist || isDirectory.boolValue || filePath.contains(".DS") {
                continue
            }

            do {
                let attributes = try fileManager.attributesOfItem(atPath: filePath)
                if let size = attributes[.size] as? Int64 {
                    totleSize += size
                }
            } catch {
                print("Error: \(error)")
            }
        }

        var totleStr = ""
        if totleSize > 1000 * 1000 {
            totleStr = String(format: "%.2fM", Float(totleSize) / 1000.00 / 1000.00)
        } else if totleSize > 1000 {
            totleStr = String(format: "%.2fKB", Float(totleSize) / 1000.00)
        } else {
            totleStr = String(format: "%.2fB", Float(totleSize) / 1.00)
        }

        return totleStr
    }

    // 清除path路径下文件夹的缓存
    class func ls_clearCache(withFilePath path: String) -> Bool {
        let fileManager = FileManager.default
        var success = true

        do {
            let subPathArr = try fileManager.contentsOfDirectory(atPath: path)
            for subPath in subPathArr {
                let filePath = (path as NSString).appendingPathComponent(subPath)
                try fileManager.removeItem(atPath: filePath)
            }
        } catch {
            success = false
            print("Error: \(error)")
        }

        return success
    }
}
