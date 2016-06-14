//
//  ViewController.swift
//  NCar-X
//
//  Created by Relvin on 16/6/6.
//  Copyright © 2016年 Relvin. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //关闭当前页面，放回主界面
    @IBAction func onBack(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true);
    }
}

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // 隐藏导航条，但由于导航条有效，系统的返回按钮页有效，所以可以使用系统的右滑返回手势。
//        [self.navigationBar setHidden:YES];
//        self.rootvi
//        self.selectedIndex = 1;
    }
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

