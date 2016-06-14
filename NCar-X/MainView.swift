//
//  MainView.swift
//  NCar-X
//
//  Created by Relvin on 16/6/6.
//  Copyright © 2016年 Relvin. All rights reserved.
//

import UIKit

class MainView: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var nav: UINavigationBar!
    
    @IBOutlet weak var _tableView: UITableView!
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 4;
    }
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (section == 0 || section == 3)
        {
             return 2;
        }
        
        return 1;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if ((self.navigationController) != nil)
        {
            let VC = MainView()
            self.navigationController?.pushViewController(VC, animated: true);
        }
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let section = indexPath.section;
        let row = indexPath.row;
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "MyTestCell")
        
        //        var string :String = self.dataArray?.objectAtIndex(indexPath.row)as String
        switch section {
        case 0:
            if (row == 0)
            {
                cell.textLabel!.text = "个人资料"
            }
            else{
                cell.textLabel!.text = "账号设置"
            }
            break;
        case 1:
            cell.textLabel!.text =  "消息设置";
            break;
        case 2:
            cell.textLabel!.text =  "隐私设置设置";
            break;
        case 3:
            if(row == 0)
            {
                cell.textLabel!.text =  "关于产品";
            }else{
                cell.textLabel!.text =  "检查新版本";
            }
            break;
        default:
            break;
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        //        cell.textLabel.text = string
        return cell
    }
    

}