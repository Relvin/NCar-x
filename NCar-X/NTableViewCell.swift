//
//  SwitchCell.swift
//  NCar-X
//
//  Created by Relvin on 16/6/17.
//  Copyright © 2016年 Relvin. All rights reserved.
//

import UIKit

protocol CellDelegateProtocol {
    func cellTableTouched(cellInfo:subComponentModel ,subIndex : Int) ;
}

class NTableViewCell: UITableViewCell {
    
    var index : Int = 0
    private var openState = false
    
    private var _cellDeletage : CellDelegateProtocol!;
    
    func setCellInfo (cellInfo : subComponentModel){
        
        switch cellInfo.type {
        case .textFieldCell:
            self.detailTextLabel!.text = cellInfo.value + cellInfo.unit;
            break;
        case .addSizeCell:
            
            break;
        case .packageCell:
            let packageConfig = CarMainModel.sharedInstance.getConfigInfoByName(cellInfo.subForm);
            
            self.detailTextLabel!.text = packageConfig[String(cellInfo.typeValue[0])]!["Name"] as? String;
            break;
        case .materialTextureCell:
            let materialConfig = CarMainModel.sharedInstance.getConfigInfoByName(cellInfo.subForm);
            self.detailTextLabel!.text = materialConfig[String(cellInfo.typeValue[0])]!["Name"] as? String;
            break;
        case .craftRecommendCell:
            self.detailTextLabel!.text = "";
            break;
        case .contentCell:
            self.detailTextLabel!.text = "";
            break;
        default:
            break;
            
        }
        self.textLabel!.text = cellInfo.name;
        openState = cellInfo.open;
        index = cellInfo.id
    
    }
    
    func getRowCount() -> Int {
        return 1;
    }
    
    func setCellDelegate(cellDelegate : CellDelegateProtocol) {
        self._cellDeletage = cellDelegate;
    }
    
    func getCellHeight() -> CGFloat {
        return self.frame.size.height;
    }
    
    func setOpenState(state : Bool) {
        openState = state;
    }
    
    func getOpenState() -> Bool {
        return openState;
    }
}

class SwitchCell: NTableViewCell,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet weak var _nameLabel: UILabel!
    
    @IBOutlet weak var _detalSwitch: UISwitch!
    
    @IBOutlet weak var _tableView: UITableView!
    
    var _additionalForm : NSDictionary!
    
    var _cellInfo : subComponentModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func switchValueChanged(sender: AnyObject) {
        _cellInfo.open = (sender as! UISwitch).on;
        
        NSNotificationCenter.defaultCenter().postNotificationName("SwitchChange", object: nil);
    }
    override func setCellInfo(cellInfo : subComponentModel) {
        self._cellInfo = cellInfo;
        _detalSwitch.setOn(cellInfo.open, animated: false);
        self._nameLabel.text = cellInfo.name;
        if (cellInfo.additionalForm != "")
        {
            self._additionalForm = CarMainModel.sharedInstance.getConfigInfoByName(cellInfo.additionalForm);
        }
        _tableView.reloadData()
    }
    
    override func getCellHeight() -> CGFloat {
        
        if (_cellInfo.open)
        {
            return 50 + CGFloat(self._cellInfo.additional.count * 50) ;
        }
        else{
            return 50 ;
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if ((self._cellDeletage) != nil)
        {
            self._cellDeletage.cellTableTouched(self._cellInfo,subIndex: indexPath.section);
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return self._cellInfo.additional.count;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let section = indexPath.section;
        var cell = tableView.dequeueReusableCellWithIdentifier("textField");
        if (cell == nil){
            cell = NTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "textField");
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
        }
        let subId = _cellInfo.getAdditionalIdByIndex(section);
        let subDict = self._additionalForm[String(subId)] as! NSDictionary;
        cell?.textLabel?.text = subDict["Name"] as? String;
        cell?.detailTextLabel?.text = _cellInfo.getAdditionalValueById(subId) + (subDict["Unit"] as? String)!;
        return cell!;
    }
    
}


class PackageCell : NTableViewCell,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var _nameLabel: UILabel!
    
    @IBOutlet weak var _detailLabel: UILabel!
    @IBOutlet weak var _detailImage: UIImageView!
    
    @IBOutlet weak var _additionalTableView: UITableView!
    
    var _cellInfo : subComponentModel!
    var _additionalForm : NSDictionary!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setCellInfo(cellInfo : subComponentModel) {
        self._cellInfo = cellInfo;
        self._nameLabel.text = cellInfo.name;
        let packageConfig = CarMainModel.sharedInstance.getConfigInfoByName(cellInfo.subForm);
        
        let packageConf = packageConfig[String(cellInfo.typeValue[0])];
        self._detailLabel.text = packageConf!["Name"] as? String;
        if ((packageConf!["HasAdditional"] as? String) == "1")
        {
            self._cellInfo.open = true;
        }
        else{
            self._cellInfo.open = false;

        }
        if (cellInfo.additionalForm != "")
        {
            self._additionalForm = CarMainModel.sharedInstance.getConfigInfoByName(cellInfo.additionalForm);
        }
        
    }
    
    override func getCellHeight() -> CGFloat {
        
        if (_cellInfo.open)
        {
            return 50 + CGFloat(self._cellInfo.additional.count * 50) ;
        }
        else{
            return 50 ;
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if ((self._cellDeletage) != nil)
        {
            self._cellDeletage.cellTableTouched(self._cellInfo,subIndex: indexPath.section);
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return self._cellInfo.additional.count;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let section = indexPath.section;
        var cell = tableView.dequeueReusableCellWithIdentifier("textField");
        if (cell == nil){
            cell = NTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "textField");
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
        }
        let subId = _cellInfo.getAdditionalIdByIndex(section);
        let subDict = self._additionalForm[String(subId)] as! NSDictionary;
        cell?.textLabel?.text = subDict["Name"] as? String;
        cell?.detailTextLabel?.text = _cellInfo.getAdditionalValueById(subId) + (subDict["Unit"] as? String)!;
        return cell!;
    }

}




