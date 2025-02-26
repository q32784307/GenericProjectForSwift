//
//  LSImageEditViewController.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/7/13.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit

protocol LSPhotoEditVCDelegate: AnyObject {
    func lsOptionalPhotoEditVC(_ controller: LSImageEditViewController, didFinishCroppingImage croppedImage: UIImage?)
}

class LSImageEditViewController: LSBaseViewController, LSCropViewDelegate {

    weak var delegate: LSPhotoEditVCDelegate?
    var image: UIImage?
    var cropView: LSCropView!
    
    init(image: UIImage?, delegate: LSPhotoEditVCDelegate?) {
        self.image = image
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13.0, *) {
            let barApp = UINavigationBarAppearance()
            barApp.backgroundColor = LSWhiteColor
            barApp.backgroundEffect = nil
            barApp.shadowColor = LSWhiteColor
            barApp.titleTextAttributes = [.foregroundColor: LSWhiteColor]
            self.navigationController?.navigationBar.scrollEdgeAppearance = barApp
            self.navigationController?.navigationBar.standardAppearance = barApp
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if #available(iOS 13.0, *) {
            let barApp = UINavigationBarAppearance()
            barApp.backgroundColor = LSWhiteColor
            barApp.backgroundEffect = nil
            barApp.shadowColor = LSWhiteColor
            barApp.titleTextAttributes = [.foregroundColor: LSBlackColor]
            self.navigationController?.navigationBar.scrollEdgeAppearance = barApp
            self.navigationController?.navigationBar.standardAppearance = barApp
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LSBlackColor

        // Do any additional setup after loading the view.
        setNavigation()
            
        cropView = LSCropView(frame: CGRect(x: 0, y: LSNAVIGATION_STATUS_HEIGHT(), width: LSScreenWidth, height: LSScreenHeight - LSNAVIGATION_STATUS_HEIGHT()))
        cropView.delegate = self
        view.addSubview(cropView)
        cropView.image = image
    }
    
    func setNavigation() {
        isHidenNaviBar = false

        if self != self.navigationController?.viewControllers.first {
            let rightButton = UIButton.init()
            rightButton.frame = CGRect(x: 0, y: 0, width: LSSYRealValue(value: 50), height: LSSYRealValue(value: 24))
            rightButton.setTitle("选取", for: .normal)
            rightButton.setTitleColor(LSBlackColor, for: .normal)
            rightButton.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
            rightButton.adjustsImageWhenHighlighted = false

            let rightView = UIView(frame: rightButton.frame)
            rightView.addSubview(rightButton)

            let rightBarButton = UIBarButtonItem(customView: rightView)
            navigationItem.rightBarButtonItem = rightBarButton
        }
    }

    @objc func rightAction() {
        delegate?.lsOptionalPhotoEditVC(self, didFinishCroppingImage: cropView.croppedImage)
    }
    
    func mmtdOptionalDidBeginingTailor(_ cropView: LSCropView) {
        
    }
    
    func mmtdOptionalDidFinishTailor(_ cropView: LSCropView) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func lsOptionalDidBeginingTailor(_ cropView: LSCropView) {

    }

    func lsOptionalDidFinishTailor(_ cropView: LSCropView) {

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
