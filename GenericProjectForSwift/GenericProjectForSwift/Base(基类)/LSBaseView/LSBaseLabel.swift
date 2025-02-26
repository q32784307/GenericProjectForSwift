//
//  LSBaseLabel.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2024/11/23.
//

import UIKit

class LSBaseLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubViews() {
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
