//
//  PushViewController.swift
//  GenericProjectForSwift
//
//  Created by 漠然丶情到深处 on 2019/12/24.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit

class PushViewController: LSBaseViewController {
    
    var headerImageView: UIImageView!
    var photoSelect: LSPhotoSelect!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        analysis()
        createSubViews()
    }
    
    func analysis() {
        
    }
    
    func createSubViews() {
        headerImageView = UIImageView.init(frame: CGRectMake(100, 100, 100, 100))
        headerImageView.backgroundColor = LSRedColor
        self.view.addSubview(headerImageView)
        
        let selectedButton = UIButton.init(frame: CGRectMake(100, 220, 100, 40))
        selectedButton.setTitle("选择图片", for: .normal)
        selectedButton.setTitleColor(LSBlackColor, for: .normal)
        selectedButton.addTarget(self, action: #selector(selectedAction), for: UIControl.Event.touchUpInside)
        self.view.addSubview(selectedButton)
        
        // 初始化配置
        photoSelect = LSPhotoSelect.init(controller: self, delegate: self)
        photoSelect.isAllowEdit = true
    }
    
    @objc func selectedAction() {
        let actionSheet = LSAndroidForActionSheet(frame: self.view.bounds, titleArr: ["从手机相册选择", "拍照"])
        actionSheet.clickHandler = { [self] tag in
            switch tag {
            case 0:
                LSNSLog("点击了相册")
                photoSelect.startPhotoSelect(LSEPhotoSelectType.fromLibrary)
                break
            case 1:
                LSNSLog("点击了拍照")
                photoSelect.startPhotoSelect(LSEPhotoSelectType.takePhoto)
                break
            default:
                break
            }
        }
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.addSubview(actionSheet)
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

extension PushViewController: LSPhotoSelectDelegate {
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
            
            // 获取指定位置的单元格
            headerImageView.image = resultImg
        }
    }
    
    // 照片选择取消后的回调
    func lsOptionalPhotoSelectDidCancelled(_ photoSelect: LSPhotoSelect) {
        // dummy
    }
}
