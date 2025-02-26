//
//  LSATTextViewBinding.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2023/7/28.
//  Copyright © 2023 漠然丶情到深处. All rights reserved.
//

import UIKit
import Foundation

let LSATTextBindingAttributeName = "TextViewBingDingFlagName"

class LSATTextViewBinding: NSObject {
    
    var name: String! = ""
    var userId = 0
    var range: NSRange! = NSRange(location: 0, length: 0)

    init(
        name: String?,
        userId: Int
    ) {
        super.init()
            self.name = name
            self.userId = userId
    }
}
