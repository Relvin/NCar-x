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

class TabBarController: UITabBarController{

    @IBOutlet weak var _naviItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        _naviItem.title = self.selectedViewController!.tabBarItem.title
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {

        _naviItem.title = item.title
    }


}

