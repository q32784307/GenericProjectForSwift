//
//  LSShareView.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/1.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit

enum LSSelectedShareItemChannel: Int {
    case LSSelectedShareItemWXFriend    = 0      // 微信好友
    case LSSelectedShareItemWXMoments   = 1      // 微信朋友圈
    case LSSelectedShareItemQQFriend    = 2      // QQ好友
    case LSSelectedShareItemQQSpace     = 3      // QQ空间
    case LSSelectedShareItemCopyLink    = 4      // 复制链接
}

class LSShareView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var itemChannel: LSSelectedShareItemChannel!
    var bgView: UIView!
    var mainCollectionView: UICollectionView!
    var iconTitleArray: [[String]]!
    var iconImageArray: [[String]]!
    var titleString: String!
    var selectedShareItemClick: ((_ typeIdenx: LSSelectedShareItemChannel) -> Void)?
    
    init(shareIconTitleArray: [[String]], iconImageArray: [[String]], titleString: String) {
        super.init(frame: CGRect.zero)
        self.iconTitleArray = shareIconTitleArray
        self.iconImageArray = iconImageArray
        self.titleString = titleString
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubViews() {
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        isUserInteractionEnabled = true
        
        bgView = UIView()
        bgView.backgroundColor = UIColor.white
        addSubview(bgView)
        
        let titleLabel = UILabel()
        titleLabel.text = titleString
        titleLabel.font = UIFont.systemFont(ofSize: LSSYRealValue(value: 16))
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bgView).offset(LSSYRealValue(value: 10));
            make.centerX.equalTo(bgView.snp.centerX);
            make.height.equalTo(LSSYRealValue(value: 40));
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4, height: LSSYRealValue(value: 80))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .vertical
        
        mainCollectionView = UICollectionView(frame: CGRect(x: 0, y: LSSYRealValue(value: 50), width: UIScreen.main.bounds.width, height: LSSYRealValue(value: 80) * CGFloat(iconTitleArray.count)), collectionViewLayout: layout)
        mainCollectionView.backgroundColor = UIColor.white
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(LSShareViewCollectionViewCell.self, forCellWithReuseIdentifier: "LSShareViewCollectionViewCell")
        bgView.addSubview(mainCollectionView)
        
        let cancelButton = UIButton()
        cancelButton.backgroundColor = LSColorUtil.ls_colorWithHexString(color: "F7F7F7", alpha: 1)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: LSSYRealValue(value: 14))
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        bgView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(mainCollectionView.snp.bottom).offset(LSSYRealValue(value: 4));
            make.left.equalTo(bgView).offset(LSSYRealValue(value: 20));
            make.right.equalTo(bgView.snp.right).offset(LSSYRealValue(value: -20));
            make.height.equalTo(LSSYRealValue(value: 44));
        }
        
        UIView.animate(withDuration: 0.5) { [self] in
            self.alpha = 1
            bgView.snp.makeConstraints { make in
                make.bottom.equalTo(self.snp.bottom).offset(0);
                make.left.equalTo(self).offset(0);
                make.size.equalTo(CGSizeMake(LSScreenWidth, LSSYRealValue(value: 100) + (LSSYRealValue(value: 80) * CGFloat(iconTitleArray.count)) + LSSafeDistanceBottom()));
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return iconTitleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconTitleArray[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LSShareViewCollectionViewCell", for: indexPath) as! LSShareViewCollectionViewCell
        
        cell.iconImageView.image = LSImageNamed(name: iconImageArray[indexPath.section][indexPath.row])
        cell.titleLabel.text = iconTitleArray[indexPath.section][indexPath.row]

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if iconTitleArray[indexPath.section][indexPath.row] == "微信" {
            itemChannel = LSSelectedShareItemChannel.LSSelectedShareItemWXFriend
        }else if iconTitleArray[indexPath.section][indexPath.row] == "朋友圈"{
            itemChannel = LSSelectedShareItemChannel.LSSelectedShareItemWXMoments
        }else if iconTitleArray[indexPath.section][indexPath.row] == "QQ"{
            itemChannel = LSSelectedShareItemChannel.LSSelectedShareItemQQFriend
        }else if iconTitleArray[indexPath.section][indexPath.row] == "QQ空间"{
            itemChannel = LSSelectedShareItemChannel.LSSelectedShareItemQQSpace
        }else if iconTitleArray[indexPath.section][indexPath.row] == "复制链接"{
            itemChannel = LSSelectedShareItemChannel.LSSelectedShareItemCopyLink
        }
        
        if let selectedShareItemClick = selectedShareItemClick {
            selectedShareItemClick(itemChannel)
        }
        
        tappedCancel()
    }
    
    @objc private func cancelAction() {
        tappedCancel()
    }
    
    private func tappedCancel() {
        UIView.animate(withDuration: 0.5, animations: { [self] in
            self.alpha = 0
            bgView.snp.makeConstraints { make in
                make.top.equalTo(self.snp.bottom).offset(0);
                make.left.equalTo(self).offset(0);
                make.size.equalTo(CGSizeMake(LSScreenWidth, LSSYRealValue(value: 100) + (LSSYRealValue(value: 80) * CGFloat(iconTitleArray.count))));
            }
        }) { (finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
