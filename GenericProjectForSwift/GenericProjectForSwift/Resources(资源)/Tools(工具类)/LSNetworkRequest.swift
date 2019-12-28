//
//  LSNetworkRequest.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/12/24.
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
        case .none:
            print("未知网络")
            break
        }
        return isExistenceNetwork
    }
    
    class func requestWithData(url: String,method: HTTPMethod,params: [String: Any]?,isOpenHUD: Bool,isCloseHUD: Bool,success:((_ responseDict: Dictionary<String, Any>?) -> Void)?, failure:((_ error: Error) -> Void)?) -> Void {
        if isOpenHUD == true {
            SVProgressHUD.show(withStatus: "加载中...")
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.setDefaultMaskType(.gradient)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
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
        AF.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: header, interceptor: nil).responseJSON { (response) in
            if(response.error == nil){
                success!((response.value as! Dictionary<String, Any>))
                print("网络请求返回数据---",JSON(response.data!))
                if isCloseHUD == true {
                    SVProgressHUD.dismiss()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }else{
                failure!(response.error!)
                if isCloseHUD == true {
                    SVProgressHUD.dismiss()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                
                IDDialog.id_show(title: nil, msg: response.debugDescription, leftActionTitle: "确定", rightActionTitle: nil, leftHandler: {
                    
                }) {
                    
                }
            }
        }
    }
}

extension LSNetworkRequest {

}
