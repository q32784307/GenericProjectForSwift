//
//  LSShareTool.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/1.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit

enum LSShareSocialType: UInt {
    case LSShareSocialTypeSina              = 0       // 新浪微博
    case LSShareSocialTypeWechatSession     = 1       // 微信好友
    case LSShareSocialTypeWechatTimeLine    = 2       // 微信朋友圈
    case LSShareSocialTypeQQ                = 4       // QQ好友
    case LSShareSocialTypeQzone             = 5       // QQ空间
}

enum LSShareContentType: Int {
    case LSShareContentTypeWebPage          = 0       // 分享网页链接
    case LSShareContentTypeMiniProgram      = 1       // 分享小程序
    case LSShareContentTypeImage            = 2       // 分享图片
    case LSShareContentTypeText             = 3       // 分享纯文本
    case LSShareContentTypeImageAndText     = 4       // 分享图文
    case LSShareContentTypeVideo            = 5       // 分享视频
    case LSShareContentTypeMusic            = 6       // 分享音乐
    case LSShareContentTypeEmoticon         = 7       // 分享表情
}

class LSShareTool {
    static let shared = LSShareTool()
        
    private weak var vc: UIViewController?
    
    private init() {
        
    }
    
    // MARK: - 定制Web类型分享面板预定义平台
    func customWebShare(with vc: UIViewController, socialType: LSShareSocialType, shareType: LSShareContentType, webData: Any) {
        shareMenuView(with: vc, socialType: socialType, shareType: shareType, data: webData)
    }
    
    // MARK: - 分享微信小程序
    func customMiniProgramShare(with vc: UIViewController, socialType: LSShareSocialType, shareType: LSShareContentType, webData: Any) {
        shareMenuView(with: vc, socialType: socialType, shareType: shareType, data: webData)
    }
    
    // MARK: - 定制Image类型分享面板预定义平台
    func customImageShare(with vc: UIViewController, socialType: LSShareSocialType, shareType: LSShareContentType, imgUrlData: Any) {
        shareMenuView(with: vc, socialType: socialType, shareType: shareType, data: imgUrlData)
    }
    
    // MARK: - 定制Text类型分享面板预定义平台
    func customTextShare(with vc: UIViewController, socialType: LSShareSocialType, shareType: LSShareContentType, textData: Any) {
        shareMenuView(with: vc, socialType: socialType, shareType: shareType, data: textData)
    }
    
    // MARK: - 分享图文（支持新浪微博）
    func customImageTextXinLangShare(with vc: UIViewController, socialType: LSShareSocialType, shareType: LSShareContentType, webData: Any) {
        shareMenuView(with: vc, socialType: socialType, shareType: shareType, data: webData)
    }
    
    // MARK: - 分享视频
    func customVideoShare(with vc: UIViewController, socialType: LSShareSocialType, shareType: LSShareContentType, webData: Any) {
        shareMenuView(with: vc, socialType: socialType, shareType: shareType, data: webData)
    }
    
    // MARK: - 分享音乐
    func customMusicShare(with vc: UIViewController, socialType: LSShareSocialType, shareType: LSShareContentType, webData: Any) {
        shareMenuView(with: vc, socialType: socialType, shareType: shareType, data: webData)
    }
    
    // MARK: - 分享微信表情
    func customEmoticonShare(with vc: UIViewController, socialType: LSShareSocialType, shareType: LSShareContentType, webData: Any) {
        shareMenuView(with: vc, socialType: socialType, shareType: shareType, data: webData)
    }
    
    // MARK: - 定制自己的分享面板预定义平台
    func shareMenuView(with vc: UIViewController, socialType: LSShareSocialType, shareType: LSShareContentType, data: Any) {
        self.vc = vc
        
        if socialType == LSShareSocialType.LSShareSocialTypeWechatSession {
            UMSocialUIManager.setPreDefinePlatforms([UMSocialPlatformType.wechatSession])
            share(platformType: UMSocialPlatformType.wechatSession, shareType: shareType, data: data)
        }else if socialType == LSShareSocialType.LSShareSocialTypeWechatTimeLine {
            UMSocialUIManager.setPreDefinePlatforms([UMSocialPlatformType.wechatTimeLine])
            share(platformType: UMSocialPlatformType.wechatTimeLine, shareType: shareType, data: data)
        }else if socialType == LSShareSocialType.LSShareSocialTypeQQ {
            UMSocialUIManager.setPreDefinePlatforms([UMSocialPlatformType.QQ])
            share(platformType: UMSocialPlatformType.QQ, shareType: shareType, data: data)
        }else if socialType == LSShareSocialType.LSShareSocialTypeQzone {
            UMSocialUIManager.setPreDefinePlatforms([UMSocialPlatformType.qzone])
            share(platformType: UMSocialPlatformType.qzone, shareType: shareType, data: data)
        }else if socialType == LSShareSocialType.LSShareSocialTypeSina {
            UMSocialUIManager.setPreDefinePlatforms([UMSocialPlatformType.sina])
            share(platformType: UMSocialPlatformType.sina, shareType: shareType, data: data)
        }else{
            
        }
        
//        UMSocialUIManager.showShareMenuViewInWindow { platformType, userInfo in
//            switch shareType {
//            case .LSShareContentTypeWebPage:
//                shareWebPage(to: platformType, data: data)
//            case .LSShareContentTypeMiniProgram:
//                shareMiniProgram(to: platformType, data: data)
//            case .LSShareContentTypeImage:
//                shareImage(to: platformType, data: data)
//            case .LSShareContentTypeText:
//                shareText(to: platformType, data: data)
//            case .LSShareContentTypeImageAndText:
//                shareImageTextXinLang(to: platformType, data: data)
//            case .LSShareContentTypeVideo:
//                shareVideo(to: platformType, data: data)
//            case .LSShareContentTypeMusic:
//                shareMusic(to: platformType, data: data)
//            case .LSShareContentTypeEmoticon:
//                shareEmoticon(to: platformType, data: data)
//            }
//        }
    }
    
    func share(platformType: UMSocialPlatformType, shareType: LSShareContentType, data: Any) {
        switch shareType {
        case .LSShareContentTypeWebPage:
            shareWebPage(to: platformType, data: data)
        case .LSShareContentTypeMiniProgram:
            shareMiniProgram(to: platformType, data: data)
        case .LSShareContentTypeImage:
            shareImage(to: platformType, data: data)
        case .LSShareContentTypeText:
            shareText(to: platformType, data: data)
        case .LSShareContentTypeImageAndText:
            shareImageTextXinLang(to: platformType, data: data)
        case .LSShareContentTypeVideo:
            shareVideo(to: platformType, data: data)
        case .LSShareContentTypeMusic:
            shareMusic(to: platformType, data: data)
        case .LSShareContentTypeEmoticon:
            shareEmoticon(to: platformType, data: data)
        }
    }
    
    // MARK: - 分享网页
    func shareWebPage(to platformType: UMSocialPlatformType, data: Any) {
        let dict = data as! [String: Any]
        let messageObject = UMSocialMessageObject()
        let shareObject = UMShareWebpageObject.shareObject(withTitle: dict["title"] as? String, descr: dict["descr"] as? String, thumImage: UIImage(named: "icon"))
        shareObject?.webpageUrl = dict["webpageUrl"] as? String
        messageObject.shareObject = shareObject
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: vc) { (data, error) in
            if let error = error {
                print("************Share fail with error \(error)*********")
            } else {
                print("response data is \(data)")
            }
        }
    }
    
    // MARK: - 分享小程序
    
    func shareMiniProgram(to platformType: UMSocialPlatformType, data: Any) {
        let dict = data as! [String: Any]
        let messageObject = UMSocialMessageObject()
        let shareObject = UMShareMiniProgramObject.shareObject(withTitle: dict["title"] as? String, descr: dict["descr"] as? String, thumImage: UIImage(named: "icon"))
//        shareObject?.webpageUrl = dict["webpageUrl"] as? String
//        shareObject?.userName = dict["userName"] as? String
//        shareObject?.path = dict["path"] as? String
//        shareObject?.hdImageData = dict["hdImageData"] as? Data
//        shareObject?.withShareTicket = dict["withShareTicket"] as? Bool ?? false
//        shareObject?.miniprogramType = dict["miniprogramType"] as? NSNumber
        messageObject.shareObject = shareObject
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: vc) { (data, error) in
            if let error = error {
                print("************Share fail with error \(error)*********")
            } else {
                print("response data is \(data)")
            }
        }
    }
    
    // MARK: - 分享图片
    func shareImage(to platformType: UMSocialPlatformType, data: Any) {
        let dict = data as! [String: Any]
        let messageObject = UMSocialMessageObject()
        let shareObject = UMShareImageObject.shareObject(withTitle: dict["title"] as? String, descr: dict["descr"] as? String, thumImage: UIImage(named: "icon"))
        shareObject?.shareImage = dict["shareImage"] as? UIImage
        messageObject.shareObject = shareObject
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: vc) { (data, error) in
            if let error = error {
                print("************Share fail with error \(error)*********")
            } else {
                print("response data is \(data)")
            }
        }
    }
    
    // MARK: - 分享文本
    func shareText(to platformType: UMSocialPlatformType, data: Any) {
        let dict = data as! [String: Any]
        let messageObject = UMSocialMessageObject()
        messageObject.shareObject = data
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: vc) { (data, error) in
            if let error = error {
                print("************Share fail with error \(error)*********")
            } else {
                print("response data is \(data)")
            }
        }
    }
    
    // MARK: - 分享图文（新浪微博）
    func shareImageTextXinLang(to platformType: UMSocialPlatformType, data: Any) {
        let dict = data as! [String: Any]
        let messageObject = UMSocialMessageObject()
        let shareObject = UMShareImageObject.shareObject(withTitle: dict["title"] as? String, descr: dict["descr"] as? String, thumImage: UIImage(named: "icon"))
        shareObject?.shareImage = dict["shareImage"] as? UIImage
        messageObject.shareObject = shareObject
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: vc) { (data, error) in
            if let error = error {
                print("************Share fail with error \(error)*********")
            } else {
                print("response data is \(data)")
            }
        }
    }
    
    // MARK: - 分享视频
    func shareVideo(to platformType: UMSocialPlatformType, data: Any) {
        let dict = data as! [String: Any]
        let messageObject = UMSocialMessageObject()
        let shareObject = UMShareVideoObject.shareObject(withTitle: dict["title"] as? String, descr: dict["descr"] as? String, thumImage: UIImage(named: "icon"))
        shareObject?.videoUrl = dict["videoUrl"] as? String
        shareObject?.thumbImage = dict["thumbImage"] as? UIImage
        messageObject.shareObject = shareObject
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: vc) { (data, error) in
            if let error = error {
                print("************Share fail with error \(error)*********")
            } else {
                print("response data is \(data)")
            }
        }
    }
    
    // MARK: - 分享音乐
    func shareMusic(to platformType: UMSocialPlatformType, data: Any) {
        let dict = data as! [String: Any]
        let messageObject = UMSocialMessageObject()
        let shareObject = UMShareMusicObject.shareObject(withTitle: dict["title"] as? String, descr: dict["descr"] as? String, thumImage: UIImage(named: "icon"))
        shareObject?.musicUrl = dict["musicUrl"] as? String
        shareObject?.musicDataUrl = dict["musicDataUrl"] as? String
        messageObject.shareObject = shareObject
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: vc) { (data, error) in
            if let error = error {
                print("************Share fail with error \(error)*********")
            } else {
                print("response data is \(data)")
            }
        }
    }
    
    // MARK: - 分享微信表情
    func shareEmoticon(to platformType: UMSocialPlatformType, data: Any) {
        let dict = data as! [String: Any]
        let messageObject = UMSocialMessageObject()
        let shareObject = UMShareEmotionObject.shareObject(withTitle: dict["title"] as? String, descr: dict["descr"] as? String, thumImage: UIImage(named: "icon"))
        shareObject?.emotionData = dict["emotionData"] as? Data
        messageObject.shareObject = shareObject
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: vc) { (data, error) in
            if let error = error {
                print("************Share fail with error \(error)*********")
            } else {
                print("response data is \(data)")
            }
        }
    }
}
