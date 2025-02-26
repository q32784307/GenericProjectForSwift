//
//  FourViewController.swift
//  GenericProjectForSwift
//
//  Created by 漠然丶情到深处 on 2019/12/21.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit

class FourViewController: LSBaseViewController, LSPhotoSelectDelegate {
    
    var photoSelect: LSPhotoSelect!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let pushButton = UIButton.init(frame: CGRectMake(100, 100, 100, 100))
        pushButton.backgroundColor = LSWhiteColor
        pushButton.addTarget(self, action: #selector(pushAction), for: UIControl.Event.touchUpInside)
        self.view.addSubview(pushButton)
        
        // 初始化配置
        photoSelect = LSPhotoSelect.init(controller: self, delegate: self)
        photoSelect.isAllowEdit = true
    }
    
    @objc func pushAction() {
        photoSelect.startPhotoSelect(LSEPhotoSelectType.fromLibrary)
    }
    
    // 裁剪图片
    func imageFromImage(_ image: UIImage, inRect rect: CGRect) -> UIImage? {
        guard let sourceImageRef = image.cgImage else {
            return nil
        }
        
        let newImageRef = sourceImageRef.cropping(to: rect)
        let newImage = UIImage(cgImage: newImageRef!)
        
        return newImage
    }
    
    // 选择完成后的回调
    func lsOptionalPhotoSelect(_ photoSelect: LSPhotoSelect, didFinishedWithImageArray imageArray: [Any]) {
        if let img = imageArray.last as? UIImage {
            var resultImg = img
            
            // 未经过剪裁（isAllowEdit = NO）的情况下，对返回图片做裁剪，以保证 1：1
            if img.size.width != img.size.height {
                if img.size.width > img.size.height {
                    let left = (img.size.width - img.size.height) / 2
                    resultImg = imageFromImage(img, inRect: CGRect(x: left, y: 0, width: img.size.height, height: img.size.height)) ?? img
                } else if img.size.width < img.size.height {
                    let top = (img.size.height - img.size.width) / 2
                    resultImg = imageFromImage(img, inRect: CGRect(x: 0, y: top, width: img.size.width, height: img.size.width)) ?? img
                }
            }
            
            //设置图片显示在imageview上
//            cell.headerImageView.image = resultImg
        }
    }
    
    // 照片选择取消后的回调
    func lsOptionalPhotoSelectDidCancelled(_ photoSelect: LSPhotoSelect) {
        // dummy
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
