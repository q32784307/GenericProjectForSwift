//
//  LSBaseMJRefreshHeaderView.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2025/2/18.
//

import UIKit
import MJRefresh

class LSBaseMJRefreshHeaderView: MJRefreshGifHeader {
    
    override func prepare() {
        super.prepare()
        
        let imgs = [LSImageNamed(name: "loading_01"), LSImageNamed(name: "loading_02"), LSImageNamed(name: "loading_03"), LSImageNamed(name: "loading_04"), LSImageNamed(name: "loading_05"), LSImageNamed(name: "loading_06"), LSImageNamed(name: "loading_07"), LSImageNamed(name: "loading_08"), LSImageNamed(name: "loading_09"), LSImageNamed(name: "loading_10")]
        
        self.lastUpdatedTimeLabel?.isHidden = true
        self.stateLabel?.isHidden = true
        
        self.setImages(imgs, for: .idle)
        self.setImages(imgs, for: .pulling)
        self.setImages(imgs, for: .refreshing)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
