//
//  OneViewController.swift
//  GenericProjectForSwift
//
//  Created by 漠然丶情到深处 on 2019/12/21.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit

class OneViewController: LSBaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        requestUrl = "/api/auction/get_car_list"
        
        modelType = OneModel.self
        analysis()
        
        mainTableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "LSBaseTableViewCell") as? LSBaseTableViewCell
        if cell == nil {
            cell = LSBaseTableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "LSBaseTableViewCell")
        }
        cell!.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if let oneModel = listArray[indexPath.row] as? OneModel {
            LSNSLog("Car name: \(oneModel.car_name)")
            cell!.textLabel?.text = oneModel.car_name
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LSSYRealValue(value: 50)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
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
