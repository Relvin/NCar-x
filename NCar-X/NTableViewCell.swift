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
        let fontSize = self.detailTextLabel?.font.lineHeight;
        self.detailTextLabel?.font = UIFont(name: "",size: fontSize!)
        self.detailTextLabel?.text = "";
        
        switch cellInfo.type {
        case .textFieldCell:
            self.detailTextLabel?.text = cellInfo.value + cellInfo.unit;
            break;
        case .addSizeCell:
            
            break;
        case .packageCell:
            let packageConfig = CarMainModel.sharedInstance.getConfigInfoByName(cellInfo.subForm);
            
            self.detailTextLabel?.text = packageConfig[String(cellInfo.typeValue[0])]!["Name"] as? String;
            break;
        case .materialTextureCell:
            let materialConfig = CarMainModel.sharedInstance.getConfigInfoByName(cellInfo.subForm);
            self.detailTextLabel?.text = materialConfig[String(cellInfo.typeValue[0])]!["Name"] as? String;
            break;
        case .craftRecommendCell:
            
            break;
        case .contentCell:
            
            break;
        default:
            break;
            
        }
        self.textLabel?.text = cellInfo.name;
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
        return 60;//self.frame.size.height;
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

    @IBOutlet weak var _view: UIView!
    @IBOutlet weak var _nameLabel: UILabel!
    
    @IBOutlet weak var _detalSwitch: UISwitch!
    
    @IBOutlet weak var _openImage: UIImageView!
    @IBOutlet weak var _tableView: UITableView!
    
    var _additionalForm : NSDictionary!
    
    var _cellInfo : subComponentModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        _view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!);
//        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]]
        _tableView.backgroundColor = UIColor.clearColor();
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
        if (cellInfo.open == true)
        {
            _openImage.image = UIImage(named: "cellSelected.png")
            _tableView.hidden = false;
            _tableView.reloadData()
        }
        else{
            _openImage.image = UIImage(named: "cellNormal.png")
            _tableView.hidden = true;
        }
        
    }
    
    override func getCellHeight() -> CGFloat {
        
        if (_cellInfo.open)
        {
            return 30 + CGFloat(self._cellInfo.additional.count * 50) ;
        }
        else{
            return 60 ;
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if ((self._cellDeletage) != nil)
        {
            self._cellDeletage.cellTableTouched(self._cellInfo,subIndex: indexPath.section);
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        if (_cellInfo.open)
        {
        return self._cellInfo.additional.count;
        }
        else
        {
            return 0;
        }
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
            cell!.backgroundColor = UIColor.clearColor()
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
    
    @IBOutlet weak var _bgImage: UIImageView!
    @IBOutlet weak var _view: UIView!
    @IBOutlet weak var _additionalTableView: UITableView!
    
    var _cellInfo : subComponentModel!
    var _additionalForm : NSDictionary!
    override func awakeFromNib() {
        super.awakeFromNib();
        _additionalTableView.backgroundColor = UIColor.clearColor();
        _view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!);
        _bgImage.image = UIImage(named: "cellNormal.png")
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
            return 30 + CGFloat(self._cellInfo.additional.count * 50) ;
        }
        else{
            return 60 ;
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
            cell!.backgroundColor = UIColor.clearColor()

        }
        let subId = _cellInfo.getAdditionalIdByIndex(section);
        let subDict = self._additionalForm[String(subId)] as! NSDictionary;
        cell?.textLabel?.text = subDict["Name"] as? String;
        cell?.detailTextLabel?.text = _cellInfo.getAdditionalValueById(subId) + (subDict["Unit"] as? String)!;
        return cell!;
    }

}

class ContentCell : NTableViewCell
{
    @IBOutlet weak var _nameLabel: UILabel!
    var _cellInfo : subComponentModel!
    var _additionalForm : NSDictionary!
    
    
    @IBOutlet weak var _detalSwitch: UISwitch!
    
    @IBOutlet weak var _textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ContentCell.textDidBeginEditing),
                                                         name: UITextViewTextDidBeginEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ContentCell.textDidEndEditing),
                                                         name: UITextViewTextDidEndEditingNotification, object: nil)
    }
    
    override func setCellInfo(cellInfo : subComponentModel) {
        _detalSwitch.setOn(cellInfo.open, animated: false);
        self._cellInfo = cellInfo;
        self._nameLabel.text = cellInfo.name;
        _textView.text = _cellInfo.content;
    }
    
    func textDidBeginEditing(pSender: AnyObject) {

    }
    func textDidEndEditing(pSender: AnyObject) {
        _cellInfo.content = _textView.text;
    }
    
    override func setCellDelegate(cellDelegate: CellDelegateProtocol) {
        super.setCellDelegate(cellDelegate);
    }
    
    
    
    @IBAction func switchValueChanged(sender: AnyObject) {
        _cellInfo.open = (sender as! UISwitch).on;
        
        NSNotificationCenter.defaultCenter().postNotificationName("SwitchChange", object: nil);
    }

    override func getCellHeight() -> CGFloat {
        
        if (_cellInfo.open)
        {
            return 150 ;
        }
        else{
            return 60 ;
        }
        
    }
    
}

class craftRecommendCell: NTableViewCell {
    
    @IBOutlet weak var _nameLabel: UILabel!
    @IBOutlet weak var _textView: UITextView!
    var _infoDict : NSDictionary!;
    var _cellInfo : subComponentModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setCellInfo(cellInfo : subComponentModel) {

        self._cellInfo = cellInfo;
        self._nameLabel.text = cellInfo.name;
        _infoDict = CarMainModel.sharedInstance.getConfigInfoByName((cellInfo.subForm));
        var chooseInfo = "";
        if (cellInfo.typeValue.count > 0)
        {
            chooseInfo = (_infoDict[String(_cellInfo.typeValue[0])]!["Name"] as? String)!;
            for index in 1 ..< _cellInfo.typeValue.count
            {
                let value = _cellInfo.typeValue[index];
                chooseInfo += " + "
                chooseInfo += (_infoDict[String(value)]!["Name"] as? String)!;
            }
        }
        
        
        _textView.text = chooseInfo;
        
    }
    
    override func getCellHeight() -> CGFloat {
        if (_textView.text == "")
        {
            return 60
        }
        else
        {
            return 56 + _textView.contentSize.height;
        }
    }
}



