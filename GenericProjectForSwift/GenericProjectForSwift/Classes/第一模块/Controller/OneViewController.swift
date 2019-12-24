//
//  OneViewController.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/12/21.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit

class OneViewController: LSBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigation()
        analysis()
        createSubViews()
    }
    
    func setNavigation() {
        navView.navColor = RedColor
        navView.titleLabelText = "首页"
        navView.isShowLeftButton = true
    }
    
    override func analysis() {
        
    }
    
    override func createSubViews() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.view.addSubview(mainTableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")
        if cell != nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "TableViewCell")
            cell?.textLabel?.font = SystemFont(FONTSIZE: SYRealValue(value: 30 / 2))
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        }
        
        if indexPath.row == 0 {
            cell?.textLabel?.text = "闲杂"
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let PushVC = PushViewController()
        self.navigationController?.pushViewController(PushVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SYRealValue(value: 100 / 2)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
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
