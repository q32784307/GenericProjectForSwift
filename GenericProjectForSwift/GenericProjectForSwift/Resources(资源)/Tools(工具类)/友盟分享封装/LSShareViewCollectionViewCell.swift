//
//  LSShareViewCollectionViewCell.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/6/1.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit

class LSShareViewCollectionViewCell: UICollectionViewCell {
    var iconImageView: UIImageView!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubViews() {
        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(0);
            make.centerX.equalTo(self.contentView.snp.centerX);
            make.size.equalTo(CGSizeMake(LSSYRealValue(value: 40), LSSYRealValue(value: 40)));
        }
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: LSSYRealValue(value: 12))
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.iconImageView.snp.bottom).offset(LSSYRealValue(value: 10));
            make.centerX.equalTo(self.contentView.snp.centerX);
        }
    }
}
