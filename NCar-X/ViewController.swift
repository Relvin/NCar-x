//
//  ViewController.swift
//  NCar-X
//
//  Created by Relvin on 16/6/6.
//  Copyright © 2016年 Relvin. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    
    @IBOutlet weak var _textView: UITextView!
    private var _index = 0
    
    private var _timer : NSTimer!
    override func viewDidLoad() {
        super.viewDidLoad()
        _timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self,selector: #selector(InfoViewController.updateTimer(_:)), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateTimer(timer : NSTimer) {
        let delta = _index % 4;
        
        var textSub = ""
        switch delta {
        case 0:
            _index = 0;
            textSub = ""
            break;
        case 1:
            textSub = "."
            break;
        case 2:
            textSub = ".."
            break;
        case 3:
            textSub = "..."
        default:
            break;
        }
        _textView.text = "敬请期待" + textSub;
        _index += 1;
        
    }
    
}

class NavigationController: UINavigationController{
    
    override func viewDidLoad() {
        super.viewDidLoad();
        if (true)
        {
            self.showViewController(LoginViewController(nibName: "LoginView",bundle: nil), sender: nil);
//            self.navigationBar.hidden = true;
//            self.interactivePopGestureRecognizer?.enabled = false;
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class TabBarController: UITabBarController{

    @IBOutlet weak var _saveBarButton: UIBarButtonItem!
    @IBOutlet weak var _naviItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(selectRightAction:)];
        let rightButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TabBarController.onButtonClicked(_:)))
        self._naviItem.rightBarButtonItem = rightButton
        _naviItem.rightBarButtonItem?.enabled = false;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        _naviItem.title = self.selectedViewController!.tabBarItem.title
    }


    func onButtonClicked(sender: UIBarButtonItem) {
        let component = CarMainModel.sharedInstance.getComponentInfo();
        if(component.name != "")
        {
            CarMainModel.sharedInstance.getComponentInfo().partsToString();
        }
        else{
            showDialog("提示", msg: "请输入零件号", delegate: nil);
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem){

        _naviItem.title = item.title
        
        if(item.tag == 1)
        {
            _naviItem.rightBarButtonItem?.title = "保存";
            _naviItem.rightBarButtonItem?.enabled = true;
        }
        else
        {
            _naviItem.rightBarButtonItem?.title = "";
            _naviItem.rightBarButtonItem?.enabled = false;
        }
        
    }
    

}

