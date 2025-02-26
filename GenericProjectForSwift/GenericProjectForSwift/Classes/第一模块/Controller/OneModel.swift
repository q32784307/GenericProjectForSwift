//
//  OneModel.swift
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2025/2/26.
//

import UIKit

class OneModel: LSBaseModel {
    var auction_car_id: String = ""
    var auction_car_no: String = ""
    var auction_session_id: String = ""
    var pic_url: String = ""
    var car_name: String = ""
    var plate_first_date: String = ""
    var kilometers: String = ""
    var plate: String = ""
    var auction_place_city_name: String = ""
    var min_price: String = ""
    var car_tips: String = ""
    var car_tips_list: [String]!
    var start_time: String = ""
    var end_time: String = ""
    var delay_seconds: String = ""
    var is_inspection: String = ""
    var is_follow: String = ""
    var simple_plate: String = ""
    var show_price: String = ""
    var price_tpis: String = ""
    var show_tips: String = ""
    var show_time: String = ""
    var count_down: String = ""
    var is_show_price: String = ""
    var is_self: String = ""
    var auction_order_id: String = ""
    var is_max: String = ""
    var my_bid_price: String = ""
    var auction_type: String = ""
    var auction_time_status_text: String = ""
    var auciton_time_status: String = ""
    var next_show_time: String = ""
    var page: String = ""
    var is_car_zhijian: String = ""
    
    
    static func deserialize(from: [[String: Any]]) -> [OneModel]? {
        // 解析逻辑
        return nil // 返回解析后的数组
    }
}
