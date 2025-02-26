//
//  ThreeViewController.swift
//  GenericProjectForSwift
//
//  Created by 漠然丶情到深处 on 2019/12/21.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit

class ThreeViewController: LSBaseTableViewController {
    
    var titleArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func analysis() {
        titleArray = ["单按钮弹窗", "双按钮弹窗", "多按钮弹窗", "自动消失弹窗", "actionSheet风格", "actionSheet自动消失", "Toast", "DatePicker", "地址picerView", "仿安卓样式", "自定义pickerview"]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titleArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "LSBaseTableViewCell") as? LSBaseTableViewCell
        if cell == nil {
            cell = LSBaseTableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "LSBaseTableViewCell")
        }
        cell!.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell!.textLabel!.text = titleArray[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // 单按钮弹窗
            LSAlertControllerUtil.ls_showSingleButtonAlert(title: "提示", message: "这是一个单按钮弹窗", buttonTitle: "确定") {
                // 单按钮点击后的操作
                print("单按钮点击")
            }
        }else if indexPath.row == 1 {
            // 双按钮弹窗
            LSAlertControllerUtil.ls_showTwoButtonAlert(title: "提示", message: "这是一个双按钮弹窗", leftButtonTitle: "取消", leftButtonAction: {
                // 左按钮点击后的操作
                print("左按钮点击")
            }, rightButtonTitle: "确定", rightButtonAction: {
                // 右按钮点击后的操作
                print("右按钮点击")
            })
        }else if indexPath.row == 2 {
            // 多按钮弹窗
            LSAlertControllerUtil.ls_showMultiButtonAlert(title: "提示", message: "这是一个多按钮弹窗", buttonInfos: [
                (title: "按钮1", action: {
                    print("按钮1点击")
                }),
                (title: "按钮2", action: {
                    print("按钮2点击")
                }),
                (title: "按钮3", action: {
                    print("按钮3点击")
                })
            ])
        }else if indexPath.row == 3 {
            // 自动消失弹窗
            LSAlertControllerUtil.ls_showAutoDismissAlert(title: "提示", message: "这是一个自动消失的弹窗", duration: 3.0) {
                // 弹窗消失后的操作
                print("弹窗自动消失")
            }
        }else if indexPath.row == 4 {
            // actionSheet风格
            LSAlertControllerUtil.ls_showMultiButtonActionSheet(title: "提示", message: "这是一个多按钮弹窗", buttonInfos: [
                (title: "按钮1", style: .default, action: {
                    print("按钮1点击")
                }),
                (title: "按钮2", style: .default, action: {
                    print("按钮2点击")
                })
            ])
        }else if indexPath.row == 5 {
            // actionSheet自动消失
            LSAlertControllerUtil.ls_showAutoDismissingActionSheet(title: "提示", message: "这是一个自动消失的底部弹窗", duration: 2.0) {
                // 弹窗消失后的操作
                print("弹窗消失")
            }
        }else if indexPath.row == 6 {
            LSToast.ls_show(message: "This is a toasThis is a toasThiThis is a toasThis is a toasThiThis is a toasThis is a toasThiThis is a toasThis is a toasThiThis is a toasThis is a toasThiThis is a toasThis is a toasThi", position: .center)
            LSNSLog("打印数据")
        }else if indexPath.row == 7 {
            // 使用示例
            let datePicker = LSDatePickerUtils(type: .yearMonthDayHourMinute, allowPastDates: true)
            datePicker.ls_showPickerInView(self.view, cancelColor: LSRedColor, confirmColor: LSBlueColor, headerTitle: "选择日期", cellFont: UIFont.systemFont(ofSize: 20), cellTextColor: LSBlackColor) { selectedDate in
                // 在此处处理选择的日期
                print(selectedDate)
            }
        }else if indexPath.row == 8 {
            let locationPickerView = LSLocationPickerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            locationPickerView.didSelectLocation = { provinceName, provinceId, cityName, cityId, districtName, districtId in
                LSNSLog("Selected location: \(provinceName) - \(provinceId) - \(cityName) - \(cityId) - \(districtName) - \(districtId)")
            }
            locationPickerView.showPickerView()
        }else if indexPath.row == 9 {
            let actionSheet = LSAndroidForActionSheet(frame: self.view.bounds, titleArr: ["从手机相册选择", "拍照"])
            actionSheet.clickHandler = { tag in
                // Handle button click based on the tag
                switch tag {
                case 0:
                    LSNSLog("点击了相册")
                    break
                case 1:
                    LSNSLog("点击了拍照")
                    break
                default:
                    break
                }
            }
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            window?.addSubview(actionSheet)
        }else{
            let pickerView = LSCustomPickerView(frame: LSScreenBounds, dataSource: [["男", "女"]])
            pickerView.selectionHandler = { (selectedValue, index) in
                print("Selected Value: \(selectedValue)")
            }
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            window?.addSubview(pickerView)
            pickerView.showPickerView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LSSYRealValue(value: 50)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
