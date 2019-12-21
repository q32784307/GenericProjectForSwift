//
//  LSBaseViewController.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/12/21.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit

class LSBaseViewController: UIViewController {
    var navView: LSBaseNavigationView!
    /**
     *  修改状态栏颜色
     */
    var StatusBarStyle: UIStatusBarStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ViewBackgroundColor
        // Do any additional setup after loading the view.
        //是否隐藏系统导航栏
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //默认导航栏样式：白字
        if #available(iOS 13.0, *) {
            StatusBarStyle = UIStatusBarStyle.darkContent
        }else {
            StatusBarStyle = UIStatusBarStyle.default
        }
        
        setNavigationView()
    }
    
    //创建自定义导航栏
    func setNavigationView() {
        navView = LSBaseNavigationView.init()
        navView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: CGFloat(NAVIGATION_BAR_HEIGHT))
        self.view.addSubview(navView)
    }
//    - (void)setNavigationView {
//        WeakSelf(self);
//        self.navView = [[LSBaseNavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NAVIGATION_BAR_HEIGHT)];
//        self.navView.isShowRightButton = NO;
//        [self.navView setLeftActionBlock:^{
//            [weakself backBtnClicked];
//        }];
//        [self.view addSubview:self.navView];
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
