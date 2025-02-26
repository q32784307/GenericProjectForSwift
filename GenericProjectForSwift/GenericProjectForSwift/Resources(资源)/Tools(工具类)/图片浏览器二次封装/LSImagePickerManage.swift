//
//  LSImagePickerManage.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/7/26.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit
import TZImagePickerController
import CoreServices

enum LSManageSelectTakeType: Int {
    case takePhoto
    case shootingVideo
    case takeVideo
    case imagePicker
    case photoAndImagePicker
}

protocol LSImagePickerManageDelegate: AnyObject {
    func selectTZImagePickerSelectedPhotos(_ selectedPhotos: [UIImage], selectedAssets: [PHAsset], isOriginalPhoto: Bool, blockData: Data, outPutPath: String, selectType: LSManageSelectTakeType)
}

class LSImagePickerManage: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate {
    
    weak var delegate: LSImagePickerManageDelegate?
    var selectedPhotos: [UIImage] = []
    var selectedAssets: [PHAsset] = []
    var isSelectOriginalPhoto: Bool = false
    var imagesURL: [URL] = []
    var maxCount: Int = 0
    weak var superViewController: UIViewController?
    var selectType: LSManageSelectTakeType = .takePhoto
    var compressionQuality: CGFloat = 0.6
    var location: CLLocation?
    var imgPickerVC: UIImagePickerController?
    
    /**打开手机图片库
     
     @param maxCount 最大张数
     @param superController superController
     @param selectType selectType
     */
    func showImagePickerController(withMaxCount maxCount: Int, viewController superController: UIViewController, selectType: LSManageSelectTakeType, assetsArr CusSelectedAssets: [PHAsset]?, photosArr CusSelectedPhotos: [UIImage]?) {
        self.maxCount = maxCount
        self.superViewController = superController
        self.selectType = selectType
        self.selectedPhotos = CusSelectedPhotos ?? []
        self.selectedAssets = CusSelectedAssets ?? []
        
        if selectType == .takePhoto || selectType == .shootingVideo {
            // 拍照 视频或图片
            takePhoto()
        } else if selectType == .takeVideo || selectType == .imagePicker {
            // 选择手机图片或视频
            pushTZImagePickerController()
        } else {
            let actionSheet = LSAndroidForActionSheet(frame: superController.view.bounds, titleArr: ["从手机相册选择", "拍照"])
            actionSheet.clickHandler = { [self] tag in
                // Handle button click based on the tag
                switch tag {
                case 0:
                    pushTZImagePickerController()
                    break
                case 1:
                    takePhoto()
                    break
                default:
                    break
                }
            }
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            window?.addSubview(actionSheet)
        }
    }
    
    /**
     选取手机图片
     */
    func pushTZImagePickerController() {
        let imagePickerVc = TZImagePickerController(maxImagesCount: maxCount, delegate: self)
            
        // 五类个性化设置，这些参数都可以不传，此时会走默认设置
        // imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto
        imagePickerVc!.selectedAssets = NSMutableArray(array: selectedAssets) // 目前已经选中的图片数组
        
        if selectType == .takeVideo {
            // 视频
            imagePickerVc!.allowTakeVideo = true // 在内部显示拍视频按钮
        } else {
            imagePickerVc!.allowTakeVideo = false // 在内部不显示拍视频按钮
        }
        
        if selectType == .imagePicker {
            imagePickerVc!.allowTakePicture = true // 在内部显示拍照按钮
        } else {
            imagePickerVc!.allowTakePicture = false // 在内部不显示拍照按钮
        }
        
        imagePickerVc!.videoMaximumDuration = 15 // 视频最大拍摄时间
        
        imagePickerVc!.uiImagePickerControllerSettingBlock = { imagePickerController in
            imagePickerController!.videoQuality = .typeHigh
        }
        
        imagePickerVc!.iconThemeColor = UIColor(red: 31/255.0, green: 185/255.0, blue: 34/255.0, alpha: 1.0)
        imagePickerVc!.showPhotoCannotSelectLayer = true
        imagePickerVc!.cannotSelectLayerColor = UIColor.white.withAlphaComponent(0.8)
        
        imagePickerVc?.photoPickerPageUIConfigBlock = { collectionView, bottomToolBar, previewButton, originalPhotoButton, originalPhotoLabel, doneButton, numberImageView, numberLabel, divideLine in
            
        }
        
        
        // 3. Set allow picking video & photo & originalPhoto or not
        if selectType == .imagePicker {
            // 选择图片
            // 是否可以选择视频
            imagePickerVc!.allowPickingVideo = false
            // 允许选择图片
            imagePickerVc!.allowPickingImage = true
            // 允许选择原图
            imagePickerVc!.allowPickingOriginalPhoto = true
        } else if selectType == .takeVideo {
            // 是否可以选择视频
            imagePickerVc!.allowPickingVideo = true
            // 允许选择图片
            imagePickerVc!.allowPickingImage = false
            // 允许选择原图
            imagePickerVc!.allowPickingOriginalPhoto = false
        } else if selectType == .photoAndImagePicker {
            // 是否可以选择视频
            imagePickerVc!.allowPickingVideo = false
            // 允许选择图片
            imagePickerVc!.allowPickingImage = true
            // 允许选择原图
            imagePickerVc!.allowPickingOriginalPhoto = true
        }
        
        // 允许选择gif
        imagePickerVc!.allowPickingGif = false
        // 是否可以多选视频
        imagePickerVc!.allowPickingMultipleVideo = false // 是否可以多选视频
        // 4. 照片排列按修改时间升序
        imagePickerVc!.sortAscendingByModificationDate = false
        imagePickerVc!.statusBarStyle = .lightContent
        // 设置是否显示图片序号
        imagePickerVc!.showSelectedIndex = true
        // 你可以通过block或者代理，来得到用户选择的照片.
        imagePickerVc!.didFinishPickingPhotosHandle = { photos, assets, isSelectOriginalPhoto in
            // Handle the selected photos and assets here
        }
        imagePickerVc!.modalPresentationStyle = .fullScreen
        superViewController!.present(imagePickerVc!, animated: true, completion: nil)
    }

    /**
     拍照
     */
    func takePhoto() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authStatus == .restricted || authStatus == .denied {
            LSAlertControllerUtil.ls_showTwoButtonAlert(title: "无法使用相机", message: "请在iPhone的\"设置-隐私-相机\"中允许访问相机", leftButtonTitle: "取消", leftButtonAction: {
                print("左按钮点击")
            }, rightButtonTitle: "设置", rightButtonAction: {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            })
        } else if authStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.takePhoto()
                    }
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .denied {
            LSAlertControllerUtil.ls_showTwoButtonAlert(title: "无法访问相册", message: "请在iPhone的\"设置-隐私-相册\"中允许访问相册", leftButtonTitle: "取消", leftButtonAction: {
                print("左按钮点击")
            }, rightButtonTitle: "设置", rightButtonAction: {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            })
        } else if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            // 未请求过相册权限
            TZImageManager.default()?.requestAuthorization {
                self.takePhoto()
            }
        } else {
            //拍照或者拍视频
            pushvideoAndImagePickerController()
        }
    }
    
    //调用相机
    func pushvideoAndImagePickerController() {
        // 提前定位
        weak var weakSelf = self
        TZLocationManager.default().startLocation(successBlock: { locations in
            if let strongSelf = weakSelf {
                strongSelf.location = locations?.first
            }
        }, failureBlock: { error in
            if let strongSelf = weakSelf {
                strongSelf.location = nil
            }
        })
        
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.delegate = self
        self.imgPickerVC = imagePickerVc
        let sourceType = UIImagePickerController.SourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerVc.sourceType = sourceType
            var mediaTypes = [String]()
            
            if self.selectType == .shootingVideo { // 拍视频
                mediaTypes.append(kUTTypeMovie as String)
                imagePickerVc.videoMaximumDuration = 15 // 视频最大拍摄时间
            }
            
            if self.selectType == .takePhoto { // 拍图片
                mediaTypes.append(kUTTypeImage as String)
                imagePickerVc.allowsEditing = true
                
                if ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 8, minorVersion: 0, patchVersion: 0)) {
                    imagePickerVc.modalPresentationStyle = .overCurrentContext
                }
            }
            
            if !mediaTypes.isEmpty {
                imagePickerVc.mediaTypes = mediaTypes
            }
            
            superViewController!.present(imagePickerVc, animated: true, completion: nil)
        } else {
            print("模拟器中无法打开照相机，请在真机中使用")
        }
    }

    // 选择图片回调
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print("如果这里有回调，请告诉我一下")
        
        if picker.mediaTypes.contains((kUTTypeImage as String)) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                // Save photo and get asset / 保存图片，获取到asset
                TZImageManager.default().savePhoto(with: image, location: self.location, completion: { (asset, error) in
                    if let error = error {
                        print("图片保存失败 \(error)")
                    } else {
                        if let asset = asset {
                            let assetModel = TZImageManager.default().createModel(with: asset)
                            self.refreshCollectionView(withAddedAsset: assetModel!.asset, image: image)
                        }
                    }
                })
            }
        } else if picker.mediaTypes.contains((kUTTypeMovie as String)) {
            // 视频
            if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                TZImageManager.default().saveVideo(with: videoURL, location: self.location, completion: { (asset, error) in
                    if let asset = asset, error == nil {
                        TZImageManager.default().getPhotoWith(asset) { photo, info, isDegraded in
                            if !isDegraded, let photo = photo {
                                self.refreshCollectionView(withAddedAsset: asset, image: photo)
                            }
                        }
                    }
                })
            }
        }
    }

    func refreshCollectionView(withAddedAsset asset: PHAsset, image: UIImage) {
        selectedAssets.append(asset)
        selectedPhotos.append(image)
        
        let data = Data()
        if let delegate = delegate {
            delegate.selectTZImagePickerSelectedPhotos(selectedPhotos, selectedAssets: selectedAssets, isOriginalPhoto: false, blockData: data, outPutPath: "", selectType: self.selectType)
        }
        
        if let phAsset = asset as? PHAsset {
            print("location:\(String(describing: phAsset.location))")
            
            TZImageManager.default().getVideoOutputPath(with: asset, presetName: AVAssetExportPreset640x480, success: { outputPath in
                if let data = try? Data(contentsOf: URL(fileURLWithPath: outputPath!)) {
                    print("视频导出到本地完成,沙盒路径为:\(outputPath)")
                    // Export completed, send video here, send by outputPath or NSData
                    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
                    // 拿到data 开始回调
                    self.requestDataBlock(data, andOutPutPath: outputPath)
                }
            }, failure: { errorMessage, error in
                print("视频导出失败:\(errorMessage ?? ""), error:\(String(describing: error))")
            })
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    // 用户点击了取消
    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController) {
        
    }

    // 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
    // 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
    // 如果isSelectOriginalPhoto为YES，表明用户选择了原图
    // 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
    // photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        // 返回图片处理
        if let photos = photos, let assets = assets as? [PHAsset] {
            selectedPhotos = NSMutableArray(array: photos) as! [UIImage]
            selectedAssets = NSMutableArray(array: assets) as! [PHAsset]
            self.isSelectOriginalPhoto = isSelectOriginalPhoto
            let data = Data()
            delegate?.selectTZImagePickerSelectedPhotos(selectedPhotos, selectedAssets: selectedAssets, isOriginalPhoto: isSelectOriginalPhoto, blockData: data, outPutPath: "", selectType: selectType)
        }
    }
    

    // 如果用户选择了一个视频且allowPickingMultipleVideo是NO，下面的代理方法会被执行
    // 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: PHAsset!) {
        if let coverImage = coverImage, let asset = asset {
            selectedPhotos = NSMutableArray(array: [coverImage]) as! [UIImage]
            selectedAssets = NSMutableArray(array: [asset]) as! [PHAsset]

            print("打印视频的宽:\(asset.pixelWidth)")
            print("打印视频的高:\(asset.pixelHeight)")
            // self.superViewController.showLoading(in: UIWindow(), withMessage: "处理中...")
            weak var weakSelf = self
            TZImageManager.default().getVideoOutputPath(with: asset, presetName: AVAssetExportPreset640x480, success: { outputPath in
                if let data = try? Data(contentsOf: URL(fileURLWithPath: outputPath!)) {
                    print("视频导出到本地完成,沙盒路径为:\(outputPath)")
                    // Export completed, send video here, send by outputPath or NSData
                    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
                    // 拿到data 开始回调
                    weakSelf?.requestDataBlock(data, andOutPutPath: outputPath)
                }
            }, failure: { errorMessage, error in
                print("视频导出失败:\(errorMessage ?? ""), error:\(String(describing: error))")
            })
        }
    }

    // MARK: ==========回调了视频==========
    func requestDataBlock(_ data: Data?, andOutPutPath outPutPath: String?) {
        // 返回图片处理
        delegate?.selectTZImagePickerSelectedPhotos(selectedPhotos, selectedAssets: selectedAssets, isOriginalPhoto: false, blockData: data!, outPutPath: outPutPath!, selectType: selectType)
    }

    // MARK: -- 内部方法
    func imageDataWrite(toFile image: UIImage) -> String {
        var data: Data?
        // 获取图片路径
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
        let filePath = path + String(format: "img_%d.jpg", arc4random())
        if image.pngData() == nil {
            data = image.jpegData(compressionQuality: self.compressionQuality)
        } else {
            // 将PNG转JPG
            try? image.jpegData(compressionQuality: self.compressionQuality)?.write(to: URL(fileURLWithPath: filePath))
            let jpgImage = UIImage(contentsOfFile: filePath)
            data = jpgImage?.jpegData(compressionQuality: self.compressionQuality)
        }
        
        try? data?.write(to: URL(fileURLWithPath: filePath))
        return filePath
    }
    
}
