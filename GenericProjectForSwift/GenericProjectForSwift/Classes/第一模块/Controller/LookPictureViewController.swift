//
//  LookPictureViewController.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/7/27.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit
import TZImagePickerController

class LookPictureViewController: LSBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LSImagePickerManageDelegate {
    
    var mainCollectionView: UICollectionView!
    lazy var helper: LSImagePickerManage = {
        let helper = LSImagePickerManage()
        helper.delegate = self
        return helper
    }()
    var imageViewSelectPhotoArray: [UIImage] = []
    var imageViewSelectAssetsArray: [PHAsset] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createSubViews()
    }
    
    func createSubViews() {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = LSSYRealValue(value: 10)
        layout.scrollDirection = .horizontal
        mainCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        mainCollectionView.showsHorizontalScrollIndicator = false
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(LookPictureCollectionViewCell.self, forCellWithReuseIdentifier: "LookPictureCollectionViewCell")
        self.view.addSubview(mainCollectionView)
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(LSNAVIGATION_STATUS_HEIGHT())
            make.left.equalTo(self.view).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.height.equalTo(LSSYRealValue(value: 86))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageViewSelectPhotoArray.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LookPictureCollectionViewCell", for: indexPath) as! LookPictureCollectionViewCell
        if indexPath.row == imageViewSelectPhotoArray.count {
            cell.imageView.image = UIImage(named: "发布_添加图片")
            cell.deleteBtn.isHidden = true
        } else {
            cell.imageView.image = imageViewSelectPhotoArray[indexPath.row] as! UIImage
            cell.deleteBtn.isHidden = false
        }
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnClik(_:)), for: .touchUpInside)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == imageViewSelectPhotoArray.count {
            helper.showImagePickerController(withMaxCount: 9, viewController: self, selectType: .photoAndImagePicker, assetsArr: imageViewSelectAssetsArray, photosArr: imageViewSelectPhotoArray)
        } else {
            if let asset = imageViewSelectAssetsArray[indexPath.item] as? PHAsset {
                var isVideo = false
                isVideo = asset.mediaType == .video
                if let filename = asset.value(forKey: "filename") as? String, filename.contains("GIF") {
                        let vc = TZGifPhotoPreviewController()
                        let model = TZAssetModel(asset: asset, type: TZAssetModelMediaTypePhotoGif, timeLength: "")
                        vc.model = model
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    } else if isVideo {
                        let vc = TZVideoPlayerController()
                        let model = TZAssetModel(asset: asset, type: TZAssetModelMediaTypeVideo, timeLength: "")
                        vc.model = model
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        let mutableAssetsArray = NSMutableArray(array: imageViewSelectAssetsArray)
                        let mutablePhotosArray = NSMutableArray(array: imageViewSelectPhotoArray)

                        let imagePickerVc = TZImagePickerController(selectedAssets: mutableAssetsArray, selectedPhotos: mutablePhotosArray, index: indexPath.item)
                        imagePickerVc!.modalPresentationStyle = .fullScreen
                        self.present(imagePickerVc!, animated: true, completion: nil)

                    }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: LSSYRealValue(value: 86), height: LSSYRealValue(value: 86))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: LSSYRealValue(value: 15), bottom: 0, right: LSSYRealValue(value: 15))
    }

    @objc func deleteBtnClik(_ sender: UIButton) {
        if collectionView(mainCollectionView, numberOfItemsInSection: 0) <= imageViewSelectPhotoArray.count {
            imageViewSelectPhotoArray.remove(at: sender.tag)
            imageViewSelectAssetsArray.remove(at: sender.tag)
            mainCollectionView.reloadData()
            return
        }

        imageViewSelectPhotoArray.remove(at: sender.tag)
        imageViewSelectAssetsArray.remove(at: sender.tag)
        mainCollectionView.performBatchUpdates({
            let indexPath = IndexPath(item: sender.tag, section: 0)
            mainCollectionView.deleteItems(at: [indexPath])
        }) { [self] finished in
            mainCollectionView.reloadData()
        }
    }
    
    func selectTZImagePickerSelectedPhotos(_ selectedPhotos: [UIImage], selectedAssets: [PHAsset], isOriginalPhoto: Bool, blockData: Data, outPutPath: String, selectType: LSManageSelectTakeType) {
        imageViewSelectPhotoArray = NSMutableArray(array: selectedPhotos) as! [UIImage]
        imageViewSelectAssetsArray = NSMutableArray(array: selectedAssets) as! [PHAsset]

        mainCollectionView.reloadData()
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
