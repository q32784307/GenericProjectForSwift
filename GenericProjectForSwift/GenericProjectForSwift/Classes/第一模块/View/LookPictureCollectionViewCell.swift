//
//  LookPictureCollectionViewCell.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/7/27.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit

class LookPictureCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var deleteBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubViews() {
        imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = LSSYRealValue(value: 6)
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(0)
            make.left.equalTo(self.contentView).offset(0)
            make.right.equalTo(self.contentView.snp.right).offset(0)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(0)
        }
        
        deleteBtn = UIButton(type: .custom)
        deleteBtn.setImage(UIImage(named: "发布_删除照片"), for: .normal)
        self.contentView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(0)
            make.right.equalTo(imageView.snp.right).offset(0)
            make.size.equalTo(CGSizeMake(LSSYRealValue(value: 20), LSSYRealValue(value: 20)))
        }
    }
}
