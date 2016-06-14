//
//  NHomeController.swift
//  NCar-X
//
//  Created by Relvin on 16/6/13.
//  Copyright © 2016年 Relvin. All rights reserved.
//

import UIKit


class NHomeController:  UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var _textField: UITextField!
    @IBOutlet weak var _nameLabel: UILabel!
    
    
    
    var cellLabel = ["零件号","到货包装形式","零件长","零件宽","零件高","叠加尺寸","包装模数","净重","零件材质","工艺推荐","备注"];
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return cellLabel.count;
    }
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1;
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if ((self.navigationController) != nil)
        {
//            var VC
//            self.navigationController?.pushViewController(VC, animated: true);
//            return;
        }
        
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        let cell = _tableView.cellForRowAtIndexPath(indexPath);
        _nameLabel.text = cell?.textLabel?.text;
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let section = indexPath.section;
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MyTestCell");
        if (cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "MyTestCell");
        }
        
        let mySwitch = UISwitch();
        cell!.accessoryView = mySwitch;
        mySwitch.addTarget(self, action: #selector(NHomeController.stateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        cell!.textLabel!.text = cellLabel[section];
        return cell!;
    }
    
    func stateChanged(switchState: UISwitch) {
        if switchState.on {
//            myTextField.text = "The Switch is On"
        } else {
//            myTextField.text = "The Switch is Off"
        }
        
    }
    
}