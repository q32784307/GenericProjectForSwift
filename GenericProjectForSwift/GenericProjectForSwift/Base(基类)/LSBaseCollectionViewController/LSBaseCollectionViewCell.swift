//
//  LSBaseCollectionViewCell.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2025/2/15.
//

import UIKit

class LSBaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubViews() {
        
    }
    
}
