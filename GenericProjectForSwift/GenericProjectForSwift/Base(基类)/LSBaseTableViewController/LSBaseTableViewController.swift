//
//  LSBaseTableViewController.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2025/1/21.
//

import UIKit
import MJRefresh
import EmptyDataSet_Swift

class LSBaseTableViewController: LSBaseViewController, UITableViewDelegate, UITableViewDataSource, EmptyDataSetSource, EmptyDataSetDelegate {
    
    var pageInt = 1
    var mainTableView: UITableView!
    var listArray = [LSBaseModel]()
    
    var requestUrl: String = ""
    var requestParams: Dictionary = Dictionary<String, Any>()
    var modelType: LSBaseModel.Type?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        analysis()
        createSubViews()
    }
    
    func analysis() {
        pageInt = 1
        
        requestParams["page"] = pageInt
        LSNetworkRequest.ls_requestWithData(url: requestUrl, method: .post, params: requestParams, isOpenHUD: true, isCloseHUD: true) { [weak self] responseDict in
            guard let self = self else { return }
            guard let dict = responseDict else {
                LSToast.ls_show(message: "请求失败", position: .center)
                return
            }
            if let config = dict["data"] as? [String: Any],
               let config2 = config["datalist"] as? [[String: Any]] {
                self.listArray = [LSBaseModel].deserialize(from: config2) as? [LSBaseModel] ?? []
            }
            
            self.mainTableView.mj_header?.endRefreshing()
            self.mainTableView.mj_footer?.resetNoMoreData()
            self.mainTableView.reloadData()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.mainTableView.mj_header?.endRefreshing()
            self.mainTableView.mj_footer?.resetNoMoreData()
            self.mainTableView.reloadData()
        }
    }
    
    func createSubViews() {
        mainTableView = UITableView.init(frame: CGRectZero, style: .grouped)
        mainTableView.backgroundColor = LSViewBackgroundColor
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.emptyDataSetSource = self
        mainTableView.emptyDataSetDelegate = self
        mainTableView.estimatedRowHeight = 0
        mainTableView.estimatedSectionHeaderHeight = 0
        mainTableView.estimatedSectionFooterHeight = 0
        mainTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        self.view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(0)
            make.leading.equalTo(self.view).offset(0)
            make.trailing.equalTo(self.view.snp.trailing).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
        
        setupRefresh()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "LSBaseTableViewCell") as? LSBaseTableViewCell
        if cell == nil {
            cell = LSBaseTableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "LSBaseTableViewCell")
        }
        cell!.selectionStyle = UITableViewCell.SelectionStyle.none

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return LSSYRealValue(value: 40)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView.init()
        
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    func setupRefresh() {
        mainTableView.mj_header = LSBaseMJRefreshHeaderView.init(refreshingTarget: self, refreshingAction: #selector(headerRereshing))
        mainTableView.mj_footer = LSBaseMJRefreshFooterView.init(refreshingTarget: self, refreshingAction: #selector(footerRereshing))
        mainTableView.mj_footer?.isAutomaticallyChangeAlpha = true
    }
    
    @objc func headerRereshing() {
        analysis()
    }
    
    @objc func footerRereshing() {
        pageInt += 1
        
        requestParams["page"] = pageInt
        LSNetworkRequest.ls_requestWithData(url: requestUrl, method: .post, params: requestParams, isOpenHUD: true, isCloseHUD: true) { [weak self] responseDict in
            guard let self = self else { return }
            guard let dict = responseDict else {
                LSToast.ls_show(message: "请求失败", position: .center)
                return
            }
            if let config = dict["data"] as? [String: Any],
              let config2 = config["datalist"] as? [[String: Any]] {
                
               let arr = [LSBaseModel].deserialize(from: config2) as? [LSBaseModel] ?? []
                self.listArray.append(contentsOf: arr)
                
                if arr.count < 10 && !self.listArray.isEmpty {
                   mainTableView.mj_footer!.endRefreshingWithNoMoreData()
               }
           }
           mainTableView.mj_footer!.endRefreshing()
           mainTableView.reloadData()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.mainTableView.mj_header?.endRefreshing()
            self.mainTableView.mj_footer?.endRefreshingWithNoMoreData()
            self.mainTableView.reloadData()
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = ""
        let attributes = [NSAttributedString.Key.font: LSFontMedium(FONTSIZE: LSSYRealValue(value: 18)), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "暂无数据"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center

        let attributes = [NSAttributedString.Key.font: LSFontRegular(FONTSIZE: LSSYRealValue(value: 14)), NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        return NSAttributedString(string: text, attributes: attributes)
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return LSImageNamed(name: "无数据占位图")
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        print("Tapped on the empty data set view")
    }
    
    /**
     无数据的时候允许下拉刷新数据
     */
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
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
