//
//  LSBaseNavigationViewController.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/12/3.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit

class LSBaseNavigationViewController: UINavigationController,UIGestureRecognizerDelegate,UINavigationControllerDelegate {

    var popDelegate: AnyObject!
    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    var popRecognizer: UIScreenEdgePanGestureRecognizer!
    var isSystemSlidBack: Bool!//是否开启系统右滑返回

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //默认开启系统右划返回
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.delegate = self
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
