//
//  LSUploadOrDownload.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/14.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import Foundation
import Alamofire

class LSUploadOrDownload {
    // 分段上传本地文件
    func uploadFileWithSegments(fileURL: URL, progressHandler: @escaping (Progress) -> Void, completion: @escaping (Result<Void, Error>) -> Void) {
        let uploadURL = "https://api.example.com/upload" // 替换为实际的上传接口地址
        let headers: HTTPHeaders = [
            "Authorization": "Bearer YourAuthToken" // 替换为实际的认证信息
        ]
        
        let segmentSize = 1024 * 1024 // 1MB
        let fileSize = getFileSize(fileURL: fileURL)
        let segmentsCount = Int(ceil(Double(fileSize) / Double(segmentSize)))
        
        let queue = DispatchQueue(label: "com.example.uploadQueue", qos: .utility, attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 0)
        
        var completedSegments = 0
        
        for segmentIndex in 0..<segmentsCount {
            let startOffset = segmentIndex * segmentSize
            let endOffset = min((segmentIndex + 1) * segmentSize, fileSize) - 1
            
            let rangeHeader = "bytes=\(startOffset)-\(endOffset)"
            let headers: HTTPHeaders = [
                "Range": rangeHeader
            ]
            
            let segmentData = getFileData(fileURL: fileURL, withOffsetRange: (startOffset, endOffset))
            
            AF.upload(
                segmentData,
                to: uploadURL,
                method: .post,
                headers: headers
            )
            .uploadProgress(queue: queue) { progress in
                progressHandler(progress)
            }
            .response(queue: queue) { response in
                if let error = response.error {
                    completion(.failure(error))
                } else {
                    completedSegments += 1
                    semaphore.signal()
                }
            }
            
            semaphore.wait()
        }
        
        if completedSegments == segmentsCount {
            completion(.success(()))
        }
    }
    
    // 分段下载文件
    func downloadFileWithSegments(fileURL: URL, progressHandler: @escaping (Progress) -> Void, completion: @escaping (Result<Void, Error>) -> Void) {
        let destinationURL = fileURL // 下载文件保存的本地路径
        
        let segmentSize = 1024 * 1024 // 1MB
        let fileSize = getFileSize(fileURL: fileURL)
        let segmentsCount = Int(ceil(Double(fileSize) / Double(segmentSize)))
        
        let queue = DispatchQueue(label: "com.example.downloadQueue", qos: .utility, attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 0)
        
        var completedSegments = 0
        
        for segmentIndex in 0..<segmentsCount {
            let startOffset = segmentIndex * segmentSize
            let endOffset = min((segmentIndex + 1) * segmentSize, fileSize) - 1
            
            let rangeHeader = "bytes=\(startOffset)-\(endOffset)"
            let headers: HTTPHeaders = [
                "Range": rangeHeader
            ]
            
            AF.download(fileURL, method: .get, headers: headers)
                .downloadProgress(queue: queue) { progress in
                    progressHandler(progress)
                }
                .responseData(queue: queue) { response in
                    if let error = response.error {
                        completion(.failure(error))
                    } else if let data = response.value {
                        let fileData = Data(data)
                        do {
                            let fileHandle = try FileHandle(forWritingTo: destinationURL)
                            fileHandle.seek(toFileOffset: UInt64(startOffset))
                            fileHandle.write(fileData)
                            fileHandle.closeFile()
                            completedSegments += 1
                            semaphore.signal()
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }
            
            semaphore.wait()
        }
        
        if completedSegments == segmentsCount {
            completion(.success(()))
        }
    }
    
    // 获取文件大小
    private func getFileSize(fileURL: URL) -> Int {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            if let fileSize = attributes[.size] as? NSNumber {
                return fileSize.intValue
            }
        } catch {
            print("Failed to retrieve file size: \(error.localizedDescription)")
        }
        return 0
    }
    
    // 提取段数据
    private func getFileData(fileURL: URL, withOffsetRange range: (startOffset: Int, endOffset: Int)) -> Data {
        do {
            let fileHandle = try FileHandle(forReadingFrom: fileURL)
            fileHandle.seek(toFileOffset: UInt64(range.startOffset))
            let length = range.endOffset - range.startOffset + 1
            let data = fileHandle.readData(ofLength: length)
            fileHandle.closeFile()
            return data
        } catch {
            print("Failed to read data with offset range: \(error.localizedDescription)")
        }
        return Data()
    }
}

//// 使用示例
//let localFileTransfer = LocalFileTransfer()
//
//// 分段上传本地文件
//let uploadFileURL = URL(fileURLWithPath: "/path/to/file.txt")
//localFileTransfer.uploadFileWithSegments(fileURL: uploadFileURL) { progress in
//    // 更新上传进度条
//    print("上传进度: \(progress.fractionCompleted)")
//} completion: { result in
//    // 处理上传完成或失败
//    switch result {
//    case .success:
//        print("上传完成")
//    case .failure(let error):
//        print("上传失败: \(error.localizedDescription)")
//    }
//}
//
//// 分段下载文件
//let downloadFileURL = URL(string: "https://www.example.com/download/file.txt")!
//localFileTransfer.downloadFileWithSegments(fileURL: downloadFileURL) { progress in
//    // 更新下载进度条
//    print("下载进度: \(progress.fractionCompleted)")
//} completion: { result in
//    // 处理下载完成或失败
//    switch result {
//    case .success:
//        print("下载完成")
//    case .failure(let error):
//        print("下载失败: \(error.localizedDescription)")
//    }
//}
