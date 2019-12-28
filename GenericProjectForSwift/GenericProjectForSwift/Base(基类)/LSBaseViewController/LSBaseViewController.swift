//
//  LSBaseViewController.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/12/21.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit
import MJRefresh

class LSBaseViewController: UIViewController {
    var navView: LSBaseNavigationView!
    //是否隐藏系统导航栏
    var isHidenNaviBar: Bool! {
        didSet {
            self.navigationController?.setNavigationBarHidden(isHidenNaviBar, animated: false)
        }
    }
    //是否开启刷新功能
    var isOpenUpDate: Bool! {
        didSet {
            if isOpenUpDate == true {
                setupRefresh()
            }
        }
    }
    
    
    lazy var mainTableView: UITableView! = {
        let tableView = UITableView(frame: CGRect(x: 0, y: CGFloat(NAVIGATION_BAR_HEIGHT), width: ScreenWidth, height: ScreenHeight - CGFloat(NAVIGATION_BAR_HEIGHT) - CGFloat(TAB_BAR_HEIGHT)), style: .grouped)
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        return tableView
    }()
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ViewBackgroundColor
        // Do any additional setup after loading the view.
        //是否隐藏系统导航栏
        isHidenNaviBar = true
    
        setNavigationView()
    }
    
    //创建自定义导航栏
    func setNavigationView() {
        navView = LSBaseNavigationView.init()
        navView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: CGFloat(NAVIGATION_BAR_HEIGHT))
        navView.leftActionBlock = {() -> Void in
            self.backBtnClicked()
        }
        self.view.addSubview(navView)
    }
    
    func backBtnClicked() {
        if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //请求数据
    func analysis() {
        
    }

    //创建布局
    func createSubViews() {
        
    }
    
    /** 该方法在UIView的分类中实现 */
    func isShowingOnKeyWindow() -> Bool {
        //主窗口
        let keyWindow: UIWindow = UIApplication.shared.keyWindow!
        // 以主窗口左上角为坐标原点, 计算self的矩形框
        let newFrame: CGRect = keyWindow.convert(self.view.frame, from: self.view.superview)
        let winBounds: CGRect = keyWindow.bounds
        
        // 主窗口的bounds 和 self的矩形框 是否有重叠
        let intersects: Bool = newFrame.intersects(winBounds)
        return !self.view.isHidden && self.view.alpha > 0.01 && self.view.window == keyWindow && intersects
    }
    
    func setupRefresh() {
        //下拉刷新
        let header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(headerRereshing))
        //隐藏时间
        header.lastUpdatedTimeLabel?.isHidden = true
        //隐藏状态
        header.stateLabel?.isHidden = true
        // 设置文字
        header.setTitle("下拉刷新数据", for: MJRefreshState.idle)
        header.setTitle("松开立即刷新", for: MJRefreshState.pulling)
        header.setTitle("Loading ...", for: MJRefreshState.refreshing)
        // 设置字体
        header.stateLabel?.font = SystemFont(FONTSIZE: 15)
        header.lastUpdatedTimeLabel?.font = SystemFont(FONTSIZE: 14)
        // 设置颜色
        header.stateLabel?.textColor = RedColor
        header.lastUpdatedTimeLabel?.textColor = BlueColor
        // 设置刷新控件
        mainTableView.mj_header = header
        
        //上拉加载
        let footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(footerRereshing))
        // 设置文字
        footer.setTitle("上拉可加载更多数据", for: MJRefreshState.idle)
        footer.setTitle("Loading more ...", for: MJRefreshState.refreshing)
        // 设置字体
        footer.stateLabel?.font = SystemFont(FONTSIZE: 17)
        // 设置颜色
        footer.stateLabel?.textColor = BlueColor
        // 设置footer
        mainTableView.mj_footer = footer
    }
    
    //Mark: 设置下拉刷新
    @objc func headerRereshing() {
        
    }
    
    //Mark: 设置上拉加载
    @objc func footerRereshing() {
        
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
