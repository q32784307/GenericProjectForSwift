//
//  LSBaseCollectionViewController.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2025/1/21.
//

import UIKit
import MJRefresh
import EmptyDataSet_Swift

class LSBaseCollectionViewController: LSBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EmptyDataSetSource, EmptyDataSetDelegate {
    
    var mainCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createSubViews()
    }
    
    func createSubViews() {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = LSSYRealValue(value: 15)
        layout.minimumLineSpacing = LSSYRealValue(value: 15)
        mainCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        mainCollectionView.backgroundColor = LSWhiteColor
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.emptyDataSetSource = self
        mainCollectionView.emptyDataSetDelegate = self
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.showsHorizontalScrollIndicator = false
        mainCollectionView.register(LSBaseCollectionViewCell.self, forCellWithReuseIdentifier: "LSBaseCollectionViewCell")
        self.view.addSubview(mainCollectionView)
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(0)
            make.leading.equalTo(self.view).offset(0)
            make.trailing.equalTo(self.view.snp.trailing).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
        setupRefresh()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LSBaseCollectionViewCell", for: indexPath) as! LSBaseCollectionViewCell
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (LSScreenWidth - LSSYRealValue(value: 45)) / 2, height: LSSYRealValue(value: 240))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: LSSYRealValue(value: 16), left: LSSYRealValue(value: 15), bottom: LSSYRealValue(value: 16), right: LSSYRealValue(value: 15))
    }
    
    func setupRefresh() {
        mainCollectionView.mj_header = LSBaseMJRefreshHeaderView.init(refreshingTarget: self, refreshingAction: #selector(headerRereshing))
        mainCollectionView.mj_footer = LSBaseMJRefreshFooterView.init(refreshingTarget: self, refreshingAction: #selector(footerRereshing))
        mainCollectionView.mj_footer?.isAutomaticallyChangeAlpha = true
    }
    
    @objc func headerRereshing() {
        
    }
    
    @objc func footerRereshing() {
        
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = ""
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "暂无数据"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center

        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: paragraphStyle]
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
