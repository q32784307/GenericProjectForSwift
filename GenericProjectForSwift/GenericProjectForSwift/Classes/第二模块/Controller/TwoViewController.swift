//
//  TwoViewController.swift
//  GenericProjectForSwift
//
//  Created by 漠然丶情到深处 on 2019/12/21.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit

class TwoViewController: LSBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let button = UIButton(frame: CGRectMake(100, 100, 100, 100))
        button.backgroundColor = LSRedColor
        button.addTarget(self, action: #selector(shareAction), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button)
        
        
        let customTextView = LSTextView()
        customTextView.bgView.layer.masksToBounds = true
        customTextView.bgView.layer.cornerRadius = 10
        customTextView.characterConuntType = false
        view.addSubview(customTextView)
        customTextView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(350)
            make.left.equalTo(self.view).offset(50)
            make.width.equalTo(200)
            make.height.equalTo(80)
        }
        customTextView.textDidChange = { text in
            print("文本内容变化：\(text)")
        }
        
        
        let textField = UITextField(frame: CGRectMake(20, 500, 100, 30))
        textField.backgroundColor = LSRedColor
        textField.keyboardType = UIKeyboardType.numberPad
        self.view.addSubview(textField)
    }
    
    @objc private func shareAction() {
        let titleArray = [["微信", "朋友圈", "QQ", "QQ空间"], ["复制链接"]]
        let iconArray = [["分享_微信", "分享_朋友圈", "分享_QQ", "分享_QQ空间"], ["分享_复制链接"]]
        
        let shareView = LSShareView.init(shareIconTitleArray: titleArray, iconImageArray: iconArray, titleString: "分享至")
        UIApplication.shared.keyWindow?.addSubview(shareView)
        shareView.selectedShareItemClick = { typeIdenx in
            if typeIdenx == LSSelectedShareItemChannel.LSSelectedShareItemWXFriend {
                print("点击了微信好友")
//                LSShareTool.shared.customTextShare(with: self, socialType: LSShareSocialType.LSShareSocialTypeWechatSession, shareType: LSShareContentType.LSShareContentTypeText, textData: "11")
            } else if typeIdenx == LSSelectedShareItemChannel.LSSelectedShareItemWXMoments {
                print("点击了微信朋友圈")
            } else if typeIdenx == LSSelectedShareItemChannel.LSSelectedShareItemQQFriend {
                print("点击了QQ好友")
//                LSShareTool.shared.customTextShare(with: self, socialType: LSShareSocialType.LSShareSocialTypeQQ, shareType: LSShareContentType.LSShareContentTypeText, textData: "11")
            } else if typeIdenx == LSSelectedShareItemChannel.LSSelectedShareItemQQSpace {
                print("点击了QQ空间")
            } else if typeIdenx == LSSelectedShareItemChannel.LSSelectedShareItemCopyLink {
                print("点击了复制链接")
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
