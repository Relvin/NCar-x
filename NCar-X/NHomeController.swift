//
//  NHomeController.swift
//  NCar-X
//
//  Created by Relvin on 16/6/13.
//  Copyright © 2016年 Relvin. All rights reserved.
//

import UIKit

enum cellType: Int32 {
    case textFieldcell
    case switchcell
    case pickcell
}

let tableData = [
    [
        "ID" : 1,
        "name" : "零件号",
        "type" : 0,
        "unit" : "",
    ],
    [
        "ID" : 1,
        "name" : "到货包装形式",
        "type" : 2,
        "unit" : "",
    ],
    [
        "ID" : 1,
        "name" : "零件长",
        "type" : 0,
        "unit" : "CM",
    ],
    [
        "ID" : 1,
        "name" : "零件宽",
        "type" : 0,
        "unit" : "CM",
    ],
    [
        "ID" : 1,
        "name" : "零件高",
        "type" : 0,
        "unit" : "CM",
    ],
    [
        "ID" : 1,
        "name" : "叠加尺寸",
        "type" : 1,
        "unit" : "",
    ],
    [
        "ID" : 1,
        "name" : "包装模数",
        "type" : 0,
        "unit" : "EA",
    ],
    [
        "ID" : 1,
        "name" : "净重",
        "type" : 0,
        "unit" : "KG",
    ],
    [
        "ID" : 1,
        "name" : "零件材质",
        "type" : 2,
        "unit" : "",
    ],
    [
        "ID" : 1,
        "name" : "工艺推荐",
        "type" : 2,
        "unit" : "",
    ],
    [
        "ID" : 1,
        "name" : "备注",
        "type" : 1,
        "unit" : "",
    ]
];


let dataInfo = [
    ["value" : "PC包装零件","text" : "分配给仓库自己包装的零件"],
    ["value" : "裸件包装 - GW","text" : "对象为进口零件或分配给供应商包装的零件，工艺一般为：直接贴，栓挂等"],
    ["value" : "软包装 - GS","text" : "对象为进口零件或分配给供应商包装的零件，工艺一般为：平口袋，气泡袋，气泡片，防锈袋（膜）、纸袋（纸箱夹扁）等"],
    ["value" : "类纸箱包装 - GH","text" : "对象为进口零件或分配给供应商包装的零件，工艺一般为：纸箱，木箱，罐装等可以直接安全上托的零件"],
    ["value" : "管类包装 - GG","text" : "对象为进口零件或分配给供应商包装的零件，工艺一般为：纸管，三角管，PVC管等管状工艺"],
]


class NHomeController:  UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var _textField: UITextField!
    @IBOutlet weak var _nameLabel: UILabel!
    @IBOutlet weak var _unitLabel: UILabel!
    
    @IBOutlet var rootView: UIView!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    var cellLabel = ["零件号","到货包装形式","零件长","零件宽","零件高","叠加尺寸","包装模数","净重","零件材质","工艺推荐","备注"];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(NHomeController.keyboardHide(_:)) );
        
        rootView.addGestureRecognizer(tapGestureRecognizer)
        _unitLabel.text = "";
        
    }

//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
//        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath);
//        return cell.frame.size.height + 20;
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return tableData.count;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1;
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        let section = indexPath.section;
        let cellData = tableData[section];
        let type = (cellData["type"] as! NSNumber).intValue;
        
        
        switch type {
        case 0:
            let cell = _tableView.cellForRowAtIndexPath(indexPath);
            _nameLabel.text = cell?.textLabel?.text;
            let unit = cellData["unit"] as? String;
            _unitLabel.text = unit;
            if (unit == "")
            {
                _textField.keyboardType = UIKeyboardType.ASCIICapable;
            }
            else{
                _textField.keyboardType = UIKeyboardType.NumberPad;
            }
            break;
        case 1:
            break;
        case 2:
            if ((self.navigationController) != nil)
            {
                let packageView = packageController(nibName:"PackageChooseView",bundle: nil);
                self.navigationController?.pushViewController(packageView, animated: true);
                return;
            }
            break;
        default:
            break;
        }
        
        
        
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let section = indexPath.section;
        
        let cellData = tableData[section];
        let type = (cellData["type"] as! NSNumber).intValue;
        var cell: UITableViewCell!;
        switch type {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("textField");
            if (cell == nil){
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "textField");
                cell!.detailTextLabel!.text = "0" + (cellData["unit"] as! String);
            }
            break;
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("switch");
            if (cell == nil){
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "switch");
                let mySwitch = UISwitch();
                cell!.accessoryView = mySwitch;
                mySwitch.addTarget(self, action: #selector(NHomeController.stateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
            break;
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("pick");
            if (cell == nil){
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "pick");
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
            break;
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("textField");
            if (cell == nil){
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "textField");
                let label = UILabel();
                cell!.accessoryView = label;
            }
                break;
            
        }
//
        
        
        
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
    @IBAction func editingDidBegin(sender: AnyObject) {
        tapGestureRecognizer.cancelsTouchesInView = true;
        
    }

    func keyboardHide(tip:UITapGestureRecognizer){
        
        if(_textField.isFirstResponder())
        {
            _textField.resignFirstResponder();
        }
        else{
            tip.cancelsTouchesInView = false;
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        _textField.resignFirstResponder();
        return true;
    }
    
}

class packageController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource
{
    
    @IBOutlet weak var _pickView: UIPickerView!
    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var _textLabel: UILabel!
    
    override func viewDidLoad() {
        _titleLabel.text = dataInfo[0]["value"]
        _textLabel.text = dataInfo[0]["text"]
//        _textLabel.sizeToFit();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 设置行数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dataInfo.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (dataInfo[row]["value"]);
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _titleLabel.text = dataInfo[row]["value"]
        _textLabel.text = dataInfo[row]["text"]
        
    }
    
}


