//
//  LSBaseTabBarViewController.swift
//  GenericProjectForSwift
//
//  Created by 社科赛斯 on 2019/11/30.
//  Copyright © 2019 漠然丶情到深处. All rights reserved.
//

import UIKit

class LSBaseTabBarViewController: UITabBarController,UITabBarControllerDelegate {
    
    var lastItem: UITabBarItem!
    var dataArray: Array<Any>!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lastItem = self.tabBar.selectedItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let bgView:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: 20))
        bgView.backgroundColor = UIColor.white
        self.tabBar.insertSubview(bgView, at: 0)
        self.delegate = self
        
        setViewControllers()
    }
    
    func setViewControllers() -> Void {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"TabBarConfigure" ofType:@"plist"];
//        NSArray *dataArray = [[NSArray alloc] initWithContentsOfFile:path];
//
//        for (NSDictionary *dataDic in dataArray) {
//            Class class = NSClassFromString(dataDic[@"class"]);
//            NSString *title = dataDic[@"title"];
//            NSString *image = dataDic[@"image"];
//            NSString *selectedImage = dataDic[@"selectedImage"];

//        }

//        let path:String = Bundle.main.path(forResource: "TabBarConfigure", ofType: "plist")!
//        let dataArray = Array(Any:Dictionary)(arrayLiteral: path)
//        for dataDic in dataArray {
//
//            print(dataDic["title"])
//        }
        
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
