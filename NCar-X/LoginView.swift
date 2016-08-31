//
//  LoginView.swift
//  NCar-X
//
//  Created by Relvin on 16/7/23.
//  Copyright © 2016年 Relvin. All rights reserved.
//

import UIKit
import Foundation


import Foundation

struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
            regex = try! NSRegularExpression(pattern: pattern,
                                            options: .CaseInsensitive)
    }
    
    func match(str: String) -> Bool {
        if let matches = regex?.matchesInString(str,
                                                options: NSMatchingOptions(rawValue: 0),
                                                range: NSMakeRange(0, str.characters.count)) {
            return matches.count > 0
        } else {
            return false
        }
    }
}

infix operator =~ {
associativity none
precedence 130
}

func =~ (lhs: String, rhs: String) -> Bool {
    return MyRegex(rhs).match(lhs) //需要前面定义的MyRegex配合
}


private let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
private let usernamePattern = "^[a-z0-9_-]{3,16}$";
private let passwordPattern = "^[a-zA-Z0-9]{6,20}$";


func showDialog(title: String,msg:String,delegate:AnyObject!) {
    let alertView = UIAlertView()
    alertView.title = title
    alertView.message = msg
    alertView.addButtonWithTitle("取消")
    alertView.addButtonWithTitle("确定")
    alertView.cancelButtonIndex=0
    alertView.delegate=delegate;
    alertView.show()
}


class LoginViewController: UIViewController {
    
    @IBOutlet var _loginView: UIView!
    @IBOutlet var _registerView: UIView!
    
    @IBOutlet weak var _viewContainer: UIView!
    @IBOutlet weak var _touchControl: UIControl!
    
    /*login View component*/
    @IBOutlet weak var _usernameTextField: UITextField!
    @IBOutlet weak var _passwordTextField: UITextField!
    @IBOutlet weak var _loginButton: UIButton!
    @IBOutlet weak var _registerButton: UIButton!
    
    /* register view component */
    @IBOutlet weak var _rUsernameTextField: UITextField!
    @IBOutlet weak var _rPasswordTextField: UITextField!
    @IBOutlet weak var _rSPasswordTextField: UITextField!
    @IBOutlet weak var _emailTextField: UITextField!
    @IBOutlet weak var _rRegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true;
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false;
        _loginView.frame = self.view.frame;
        self._viewContainer.addSubview(_loginView);
        _touchControl.hidden = true;
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        _loginView.frame = self.view.frame;
        _registerView.frame = self.view.frame;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func uicontrolTouch(sender: AnyObject) {
        _touchControl.hidden = true;
        self.view.endEditing(true);
    }
    
    func keyboardWillShow(aNotification: NSNotification) {
        
        _touchControl.hidden = false;
        let userinfo: NSDictionary = aNotification.userInfo!
        let nsValue = userinfo.objectForKey(UIKeyboardFrameEndUserInfoKey)
        let keyboardRec = nsValue?.CGRectValue()
        let height = keyboardRec?.size.height
        
        
//        var offset = height!;
//        if (touchView.hidden == false)
//        {
//            let indexPath = NSIndexPath(forRow: 0, inSection: selectedIndex)
//            let rectIntable = _tableView.rectForRowAtIndexPath(indexPath);
//            let rect = _tableView.convertRect(rectIntable, toView: self.view);
//            
//            offset -= (self.view.frame.height - rect.origin.y - rect.height);
//        }
//        else{
//            touchView.hidden = false;
//            offset -= 50;
//        }
//        
//        self.animateTextField(offset);
        
    }
    
    @IBAction func onButtonClickRegister(sender: UIButton) {
        if (sender == _registerButton)
        {
            self._viewContainer.addSubview(_registerView);
        }
        else
        {
            let userName = _rUsernameTextField.text;
            let password = _rPasswordTextField.text;
            let sPassword = _rSPasswordTextField.text;
            let email = _emailTextField.text;
            
            if (userName! =~ usernamePattern) == false {
                showDialog("提示", msg: "用户名格式不正确", delegate: nil);
                return ;
            }
            if (password! =~ passwordPattern) == false
            {
                showDialog("提示", msg: "密码格式不正确", delegate: nil);
                return ;
            }
            
            if (sPassword! != password)
            {
                showDialog("提示", msg: "两次密码不一致", delegate: nil);
                return ;
            }
            
            if (email! =~ mailPattern) == false {
                showDialog("提示", msg: "邮箱格式不正确", delegate: nil);
                return ;
            }
            
            self._registerView.removeFromSuperview();
        }
        
    }
    @IBAction func editingDidEnd(sender: UITextField) {
        self.uicontrolTouch(_touchControl);
    }

    @IBAction func onButtonClickLogin(sender: AnyObject) {
        let userName = _usernameTextField.text;
        let password = _passwordTextField.text;
        
        if (userName! =~ usernamePattern) == false {
            showDialog("提示", msg: "用户名格式不正确", delegate: nil);
            return ;
        }
        if (password! =~ passwordPattern) == false
        {
            showDialog("提示", msg: "密码格式不正确", delegate: nil);
            return ;
        }
        self.view.userInteractionEnabled = false;
        FTPNet.sharedInstance.login(userName!, password: password!){
            (ret, error) -> Void in
            if (ret == true)
            {
                self.navigationController?.navigationBar.hidden = false;
                self.navigationController?.interactivePopGestureRecognizer?.enabled = true;
                self.navigationController?.popViewControllerAnimated(true);
            }
            else
            {
                showDialog("提示", msg: "用户不存在", delegate: nil);
                self.view.userInteractionEnabled = true
            }

        }
                
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
