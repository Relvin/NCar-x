//
//  NMainController.swift
//  NCar-X
//
//  Created by Relvin on 16/7/10.
//  Copyright © 2016年 Relvin. All rights reserved.
//

import UIKit

class NMainController:  UIViewController{
    
    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var _noticeText: UITextView!
    private var _timer: NSTimer!
    override func viewDidLoad() {
        super.viewDidLoad();
        _timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(NMainController.updateTimer(_:)), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
    }
    
    func updateTimer(timer : NSTimer) {
        let animation = CATransition();
//        animation.delegate = self;
        animation.duration = 0.2;
        
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)//UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade
//        animation.subtype = kCATransitionFromBottom;
        animation.removedOnCompletion = false;
        
//        animation.fillMode = kCAFillModeBackwards;
        

        let color = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let color1 = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let color2 = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        _titleLabel.textColor = UIColor(red: color, green: color1, blue: color2, alpha: 1);
        self._titleLabel.layer.addAnimation(animation, forKey: nil);
    }
}