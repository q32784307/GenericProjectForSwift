//
//  LSNetworkRequest.swift
//  GenericProjectForSwift
//
//  Created by 漠然丶情到深处 on 2019/12/24.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Reachability
import IDealist

class LSNetworkRequest : NSObject {
    static let sharedInstance = LSNetworkRequest()
    override init() {
        super.init()
    }
    
    //Mark: 网络监测
    func isNetWorkConnectionAvailable() -> Bool {
        var isExistenceNetwork: Bool = true
        let reach = try! Reachability()
        switch reach.connection {
        case .wifi:
            isExistenceNetwork = true
            print("WiFi")
            break
        case .cellular:
            isExistenceNetwork = true
            print("移动数据网络")
            break
        case .unavailable:
            isExistenceNetwork = false
            print("无网络")
            break
        }
        return isExistenceNetwork
    }
    
    class func ls_requestWithData(url: String,method: HTTPMethod,params: [String: Any]?,isOpenHUD: Bool,isCloseHUD: Bool,success:((_ responseDict: Dictionary<String, Any>?) -> Void)?, failure:((_ error: Error) -> Void)?) -> Void {
        if isOpenHUD == true {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.setDefaultMaskType(.gradient)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        var mergedParams = params ?? [:]
        
        //请求头信息
        var header = HTTPHeaders()
        //项目名称
        let executableFile: String = Bundle.main.infoDictionary!["CFBundleExecutable"]! as! String
        // app版本
        let app_Version: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        //当前设备
        let device: String = UIDevice.current.model
        //系统版本
        let systemVersion: String = UIDevice.current.systemVersion
        //屏幕分辨率
        let mainScreen: String = String.init(format: "%0.2f", UIScreen.main.scale)
        //请求头---User-Agent
        let userAgentString = "iOS" + "/" + executableFile + "/" + app_Version + "(" + device + ";" + "iOS" + systemVersion + ";" + "Scale/" + mainScreen
        header.add(name: "User-Agent", value: userAgentString)
        
        let requestUrl = LSBaseUrl + url
        AF.request(requestUrl, method: method, parameters: mergedParams, encoding: URLEncoding.default, headers: header, interceptor: nil) { (request) in
            request.timeoutInterval = 20
        }.response { (response) in
            if response.error == nil {
                if isCloseHUD == true {
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                }
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any] {
                        LSNSLog("接口地址是：\(requestUrl)\n----入参是：\(mergedParams)\n----网络请求返回数据：\(jsonDict)")
                        if let code = jsonDict["code"] as? Int, let message = jsonDict["message"] as? String {
                            success?(jsonDict)
                        } else {
                            DispatchQueue.main.async {
                                failure?(NSError(domain: "com.yourapp.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "返回数据格式错误"]))
                                LSToast.ls_show(message: "请求错误", position: .center)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            failure?(NSError(domain: "com.yourapp.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "无法解析数据"]))
                            LSToast.ls_show(message: "请求错误", position: .center)
                        }
                    }
                } catch let parseError {
                    DispatchQueue.main.async {
                        failure?(parseError)
                        LSToast.ls_show(message: "请求错误", position: .center)
                        LSNSLog("接口地址是：\(requestUrl)\n----入参是：\(mergedParams)\n----请求失败：\(parseError.localizedDescription)")
                    }
                }
            } else {
                if isCloseHUD == true {
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                }
                DispatchQueue.main.async {
                    failure?(response.error!)
                    LSNSLog("接口地址是：\(requestUrl)\n----入参是：\(mergedParams)\n----请求失败2：\(JSON(response.debugDescription))")
                }
            }
        }
    }
}



////
////  LSNetworkRequest.swift
////  GenericProjectForSwift
////
////  Created by 漠然丶情到深处 on 2019/12/24.
////  Copyright © 2019 漠然丶情到深处. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import SwiftyJSON
//import SVProgressHUD
//import Reachability
//import IDealist
//import CommonCrypto
//
//class LSNetworkRequest : NSObject {
//    static let sharedInstance = LSNetworkRequest()
//    override init() {
//        super.init()
//    }
//    
//    //Mark: 网络监测
//    func isNetWorkConnectionAvailable() -> Bool {
//        var isExistenceNetwork: Bool = true
//        let reach = try! Reachability()
//        switch reach.connection {
//        case .wifi:
//            isExistenceNetwork = true
//            print("WiFi")
//            break
//        case .cellular:
//            isExistenceNetwork = true
//            print("移动数据网络")
//            break
//        case .unavailable:
//            isExistenceNetwork = false
//            print("无网络")
//            break
//        }
//        return isExistenceNetwork
//    }
//    
//    class func ls_requestWithData(url: String, method: HTTPMethod, params: [String: Any]?, isOpenHUD: Bool, isCloseHUD: Bool, success:((_ responseDict: Dictionary<String, Any>?) -> Void)?, failure:((_ error: Error) -> Void)?) -> Void {
//        if isOpenHUD == true {
//            SVProgressHUD.setDefaultStyle(.light)
//            SVProgressHUD.setDefaultAnimationType(.native)
//            SVProgressHUD.setDefaultMaskType(.clear)
//        }
//        
//        var mergedParams = params ?? [:]
//        mergedParams["app_user_id"] = "1"
//        mergedParams["sign"] = ls_createQueryStringAndEncrypt(from: mergedParams, token: "LLP4F697B64817B9352BA669B3E2111A1D790DE6G2888E82E2C542317129B2C4123C5941A2461289769AA95B7D7ABCBA")
//        
//        var header = HTTPHeaders()
//        header.add(name: "Authorization", value: "LLP4F697B64817B9352BA669B3E2111A1D790DE6G2888E82E2C542317129B2C4123C5941A2461289769AA95B7D7ABCBA")
//        
//        // app版本
//        let app_Version: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//        //系统版本
//        let systemVersion: String = UIDevice.current.systemVersion
//        //请求头---User-Agent
//        var userAgent: Dictionary = Dictionary<String, Any>()
//        userAgent["version"] = app_Version
//        userAgent["from"] = "iOS " + systemVersion
//        header.add(name: "User-Agent", value: dictionaryToJSONString(userAgent)!)
//
//        let requestUrl = LSBaseUrl + url
//        
//        AF.request(requestUrl, method: method, parameters: mergedParams, encoding: URLEncoding.default, headers: header, interceptor: nil) { (request) in
//            request.timeoutInterval = 20
//        }.response { (response) in
//            if response.error == nil {
//                if isCloseHUD == true {
//                    DispatchQueue.main.async {
//                        SVProgressHUD.dismiss()
//                    }
//                }
//                do {
//                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any] {
//                        LSNSLog("接口地址是：\(requestUrl)\n----入参是：\(mergedParams)\n----网络请求返回数据：\(jsonDict)")
//                        if let code = jsonDict["code"] as? Int, let message = jsonDict["message"] as? String {
//                            if code == 0 {
//                                success?(jsonDict)
//                            }else if code == 1 {
//                                failure?(NSError(domain: "com.yourapp.error", code: 1, userInfo: [NSLocalizedDescriptionKey: message]))
//                            }else if code == 2 {
//                                failure?(NSError(domain: "com.yourapp.error", code: 2, userInfo: [NSLocalizedDescriptionKey: message]))
//                            } else {
//                                DispatchQueue.main.async {
//                                    failure?(NSError(domain: "com.yourapp.error", code: -1, userInfo: [NSLocalizedDescriptionKey: message]))
//                                    LSToast.ls_show(message: message, position: .center)
//                                }
//                            }
//                        } else {
//                            DispatchQueue.main.async {
//                                failure?(NSError(domain: "com.yourapp.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "返回数据格式错误"]))
//                                LSToast.ls_show(message: "请求错误", position: .center)
//                            }
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            failure?(NSError(domain: "com.yourapp.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "无法解析数据"]))
//                            LSToast.ls_show(message: "请求错误", position: .center)
//                        }
//                    }
//                } catch let parseError {
//                    DispatchQueue.main.async {
//                        failure?(parseError)
//                        LSToast.ls_show(message: "请求错误", position: .center)
//                        LSNSLog("接口地址是：\(requestUrl)\n----入参是：\(mergedParams)\n----请求失败：\(parseError.localizedDescription)")
//                    }
//                }
//            } else {
//                if isCloseHUD == true {
//                    DispatchQueue.main.async {
//                        SVProgressHUD.dismiss()
//                    }
//                }
//                DispatchQueue.main.async {
//                    failure?(response.error!)
//                    LSNSLog("接口地址是：\(requestUrl)\n----入参是：\(mergedParams)\n----请求失败2：\(JSON(response.debugDescription))")
//                }
//            }
//        }
//    }
//    
//    class func ls_createQueryStringAndEncrypt(from dictionary: [String: Any]?, token: String) -> String? {
//        guard var dictionary = dictionary else {
//            return ""
//        }
//        
//        // 确保 token 参数放到最后
//        dictionary["token"] = token
//        
//        // 排序字典中的参数，但不包括 token（确保 token 永远是最后一个）
//        let sortedParams = dictionary.filter { $0.key != "token" }.sorted { $0.key < $1.key }
//        
//        // 创建一个包含排序后的参数和 token 的数组
//        var sortedDictionary = sortedParams
//        if let tokenValue = dictionary["token"] {
//            sortedDictionary.append(("token", tokenValue))
//        }
//
//        // 拼接查询字符串
//        let queryString = sortedDictionary.compactMap { (key, value) -> String? in
//            if let valueString = value as? String {
//                return "\(key)=\(valueString)"
//            } else if let valueInt = value as? Int {
//                return "\(key)=\(valueInt)"
//            } else if let valueBool = value as? Bool {
//                return "\(key)=\(valueBool ? "true" : "false")"
//            }
//            return nil
//        }.joined(separator: "&")
//        
//        // 返回加密后的结果
//        return ls_md5(queryString)
//    }
//
//    class func ls_md5(_ string: String) -> String {
//        LSNSLog("打印加密数据---\(string)")
//        let data = Data(string.utf8)
//        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
//        data.withUnsafeBytes {
//            _ = CC_MD5($0.baseAddress, CC_LONG(data.count), &digest)
//        }
//        return digest.map { String(format: "%02x", $0) }.joined()
//    }
//    
//    class func dictionaryToJSONString(_ dictionary: [String: Any]) -> String? {
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
//            // 将 JSON 数据转换为字符串
//            return String(data: jsonData, encoding: .utf8)
//        } catch {
//            print("字典转 JSON 失败: \(error.localizedDescription)")
//            return nil
//        }
//    }
//}
