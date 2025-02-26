//
//  LSPhotoSelect.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/7/13.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit

@objc protocol LSPhotoSelectDelegate {
    @objc optional func lsOptionalPhotoSelect(_ photoSelect: LSPhotoSelect, didFinishedWithImageArray imageArray: [Any])
    @objc optional func lsOptionalPhotoSelectDidCancelled(_ photoSelect: LSPhotoSelect)
}

enum LSEPhotoSelectType: Int {
    case takePhoto
    case fromLibrary
}

class LSPhotoSelect: NSObject, LSPhotoEditVCDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate: LSPhotoSelectDelegate?
    weak var viewController: UIViewController?
    private(set) var pickerController: UIImagePickerController?
    var isAllowEdit: Bool = false
    var maxSelectCount: Int = 0
    var multiPickImage: Bool = false
    private var imageArray: [Any] = []
    
    init(controller: UIViewController?, delegate: LSPhotoSelectDelegate?) {
        self.viewController = controller
        self.delegate = delegate
        self.imageArray = []
    }
    
    func startPhotoSelect(_ type: LSEPhotoSelectType) {
        switch type {
        case .takePhoto:
            showTakePhotoView()
        case .fromLibrary:
            showPhotoSelectView()
        }
    }
    
    var selectedImageArray: [Any] {
        return imageArray
    }
    
    private func showTakePhotoView() {
        let picker = UIImagePickerController()
        pickerController = picker
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        viewController?.present(picker, animated: true, completion: nil)
    }
    
    private func showPhotoSelectView() {
        let picker = UIImagePickerController()
        pickerController = picker
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .fullScreen
        viewController?.present(picker, animated: true, completion: nil)
    }
    
    func selectedFinished(_ imageArray: [Any]) {
        // 清空之前保存的照片列表
        self.imageArray.removeAll()
        
        self.imageArray.append(contentsOf: imageArray)

        delegate?.lsOptionalPhotoSelect!(self, didFinishedWithImageArray: self.imageArray)
        self.pickerController?.dismiss(animated: true, completion: nil)
    }

    func selectedCancelled() {
        delegate?.lsOptionalPhotoSelectDidCancelled!(self)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        if isAllowEdit {
            if let selectedImage = selectedImage {
                let vc = LSImageEditViewController(image: selectedImage, delegate: self)
                picker.view.backgroundColor = .white
                picker.pushViewController(vc, animated: true)
            }
        } else {
            if let selectedImage = selectedImage {
                imageArray = [selectedImage]
                delegate?.lsOptionalPhotoSelect?(self, didFinishedWithImageArray: imageArray)
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [self] in
            selectedCancelled()
        }
    }

    func lsOptionalPhotoEditVC(_ controller: LSImageEditViewController, didFinishCroppingImage croppedImage: UIImage?) {
        if let croppedImage = croppedImage {
            selectedFinished([croppedImage])
        } else {
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
