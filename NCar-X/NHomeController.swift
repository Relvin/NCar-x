//
//  NHomeController.swift
//  NCar-X
//
//  Created by Relvin on 16/6/13.
//  Copyright © 2016年 Relvin. All rights reserved.
//  Relvin.NCar-X

import UIKit


class HomeNaviController : UINavigationController,UINavigationBarDelegate{
    var naviBar : UINavigationBar!;
    
    internal func navigationBar(navigationBar: UINavigationBar, didPopItem item: UINavigationItem){
//        self.rootViewController;
//        self.topViewController?.updateViewConstraints();
//        (self.topViewController as? NHomeController)?.refreshLayer();
    }
};

class NHomeController:  UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CellDelegateProtocol{
    
    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var _textField: UITextField!
    @IBOutlet weak var _nameLabel: UILabel!
    @IBOutlet weak var _unitLabel: UILabel!
    
    @IBOutlet var rootView: UIView!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    var selectedIndex: Int = 0
    var subIndex: Int = -1
    
    var isOpen = false;
    
    var _curTableViewCell: UITableViewCell!
    
    var _homeData : ComponentModel!

    var _firstLoad : Bool = true;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        _homeData = CarMainModel.sharedInstance.getComponentInfo();
        
        _tableView.reloadData();

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(NHomeController.keyboardHide(_:)) );
        
        view.addGestureRecognizer(tapGestureRecognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(UIViewController.updateViewConstraints),
                                                         name: "SwitchChange", object: nil)
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView(_tableView, didSelectRowAtIndexPath: indexPath);
        
    }
    
    override func updateViewConstraints (){
        super.updateViewConstraints();
        
        _homeData = CarMainModel.sharedInstance.getComponentInfo();
        _tableView.reloadData();
    }
    
    func cellTableTouched(cellInfo:subComponentModel ,subIndex : Int)
    {
        selectedIndex = cellInfo.id
        self.subIndex = subIndex;
        
        var unit = ""
        if (subIndex != -1)
        {
            
            let subId = cellInfo.getAdditionalIdByIndex(subIndex);
            unit = cellInfo.getAdditionalUnitById(subId);
            _textField.text = cellInfo.getAdditionalValueById(subId);
            _unitLabel.text = unit;
            _nameLabel.text = cellInfo.getAdditionalNameById(subId);
        }
        else
        {
            unit = cellInfo.unit;
            _textField.text = cellInfo.value;
            _unitLabel.text = unit;
            _nameLabel.text = cellInfo.name;
        }
        
        if (unit == "")
        {
            _textField.keyboardType = UIKeyboardType.ASCIICapable;
        }
        else{
            _textField.keyboardType = UIKeyboardType.NumberPad;
        }
        if (_firstLoad == false)
        {
            _textField.becomeFirstResponder()
        }
        _firstLoad = false;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as! NTableViewCell;
//        let section = indexPath.section;
        
        return cell.getCellHeight();
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return _homeData.count;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{

        return 1;
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){

        let section = indexPath.section;
        let cellData = _homeData.getPartById(section);
        let type = cellData.type
//        let cell = _tableView.cellForRowAtIndexPath(indexPath) as! NTableViewCell;
        
        switch type {
        case .textFieldCell:
            
            self.cellTableTouched(cellData, subIndex: -1);
            break;
        case .addSizeCell:
            
            break;
            
        case .packageCell:
            if ((self.navigationController) != nil)
            {
                let packageView = packageController(cellInfo: cellData,nibName: "PackageChooseView",bundle: nil);
                self.navigationController?.pushViewController(packageView, animated: true);
                _curTableViewCell = _tableView.cellForRowAtIndexPath(indexPath);
                return;
            }
            break;
        case .materialTextureCell:
            if ((self.navigationController) != nil)
            {
                let packageView = MultTablViewController(cellInfo: cellData,nibName:"MultTableView",bundle: nil);
                self.navigationController?.pushViewController(packageView, animated: true);
                _curTableViewCell = _tableView.cellForRowAtIndexPath(indexPath);
                return;
            }
            break;
            
        case .craftRecommendCell:
            
            if ((self.navigationController) != nil)
            {
                let packageView = MultTablViewController(cellInfo: cellData,nibName:"MultTableView",bundle: nil);
                self.navigationController?.pushViewController(packageView, animated: true);
                _curTableViewCell = _tableView.cellForRowAtIndexPath(indexPath);
                return;
            }
            break;
            
        case .contentCell:
            break;
        default:
            break;
        }
        
        
        
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let section = indexPath.section;
        
//        print (_homeData)
        let cellData = _homeData.getPartById(section);
        
        let type = cellData.type
        
        var cell: UITableViewCell!;
        switch type {
        case .textFieldCell:
            cell = tableView.dequeueReusableCellWithIdentifier("textField");
            if (cell == nil){
                cell = NTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "textField");
            }
            break;
        case .addSizeCell:
            cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell");
            if (cell == nil){
                cell = NSBundle.mainBundle().loadNibNamed("SwitchCell", owner: nil, options: nil).first as? SwitchCell
                
                cell?.frame = CGRect(x: 0, y: 0, width: self._tableView.frame.width, height: cell.frame.height)
                cell?.center = self._tableView.center
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
            break;
        case .packageCell:
            cell = tableView.dequeueReusableCellWithIdentifier("PackageCell");
            if (cell == nil){
                cell =   NSBundle.mainBundle().loadNibNamed("PackageCell", owner: nil, options: nil).first as? PackageCell
                cell?.frame = CGRect(x: 0, y: 0, width: self._tableView.frame.width, height: cell.frame.height)
                cell?.center = self._tableView.center
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
            break;
        case .materialTextureCell:
            cell = tableView.dequeueReusableCellWithIdentifier("pick");
            if (cell == nil){
                cell = NTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "pick");
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
            break;
            
        case .craftRecommendCell:
            cell = tableView.dequeueReusableCellWithIdentifier("pick");
            if (cell == nil){
                cell = NTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "pick");
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
            break;
        case .contentCell:
            cell = tableView.dequeueReusableCellWithIdentifier("pick");
            if (cell == nil){
                cell = NTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "pick");
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
            break;
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("textField");
            if (cell == nil){
                cell = NTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "textField");
                let label = UILabel();
                cell!.accessoryView = label;
            }
                break;
            
        }
//
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let ncell = (cell as! NTableViewCell)
        ncell.setCellInfo(cellData!);
        ncell.setCellDelegate(self);
        
        
        
        
        return cell!;
    }
    
    
    @IBAction func editingDidBegin(sender: AnyObject) {
        tapGestureRecognizer.cancelsTouchesInView = true;
        (sender as! UITextField).text = "";
    }

    @IBAction func editingDidEnd(sender: AnyObject) {
        var inputStr = (sender as! UITextField).text;
        
        
        let partData = _homeData.getPartById(selectedIndex)//CarMainModel.sharedInstance.getComponentInfo().getPartById(_selectFieldCell.index)
        if (inputStr == "" && partData.unit != "")
        {
            inputStr = "0";
        }
        if (subIndex == -1)
        {
            partData.value = inputStr!;
        }
        else{
            let subId = partData.getAdditionalIdByIndex(subIndex);
            partData.setAdditionalValueById(subId, value: inputStr!);
        }
        
        _tableView.reloadData();
//            _selectFieldCell.detailTextLabel?.text = inputStr! + partData.unit;
//        }
        
        
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
//    Relvin.NCar-X
    @IBOutlet weak var _pickView: UIPickerView!
    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var _textLabel: UILabel!
    
    var _infoDict: NSDictionary!
    var _cellInfo : subComponentModel!
    
    init(cellInfo : subComponentModel?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        _cellInfo = cellInfo!;
        _infoDict = CarMainModel.sharedInstance.getConfigInfoByName((cellInfo?.subForm)!);
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let index = _cellInfo.typeValue[0];
        _pickView.selectRow(index, inComponent: 0, animated: false);
        _titleLabel.text = _infoDict[String(index)]!["Name"] as? String
        _textLabel.text = _infoDict[String(index)]!["Text"] as? String
//        _textLabel.sizeToFit();
        self.title = _cellInfo.name;
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
        
        return _infoDict.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (_infoDict[String(row)]!["Name"] as! String);
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _titleLabel.text = _infoDict[String(row)]!["Name"] as? String
        _textLabel.text = _infoDict[String(row)]!["Text"] as? String
        
        _cellInfo.typeValue = [row]
        
    }
    
    
}

class MultTablViewController : UIViewController ,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var _tableView: UITableView!
    var _cellInfo : subComponentModel!
    var _infoDict : NSDictionary!;
    var _chooseList : [Int];
    
    init(cellInfo : subComponentModel?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self._cellInfo = cellInfo!;
        _infoDict = CarMainModel.sharedInstance.getConfigInfoByName((cellInfo?.subForm)!);
        self._chooseList = cellInfo!.typeValue;
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.automaticallyAdjustsScrollViewInsets = false;
        self.title = _cellInfo.name;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return _infoDict.count;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if (self._cellInfo?.multChoose == false)
        {
            let section = indexPath.section;
            _cellInfo?.typeValue = [section];
            self.navigationController?.popViewControllerAnimated(true);
        }
        
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let section = indexPath.section;
        var cell = tableView.dequeueReusableCellWithIdentifier("textField");
        if (cell == nil){
            cell = NTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "textField");
            if (self._cellInfo?.multChoose == true)
            {
                
                let mySwitch = NSwitch();
                mySwitch.addTarget(self, action: #selector(MultTablViewController.stateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)

                cell?.accessoryView = mySwitch;
                cell?.selectionStyle = UITableViewCellSelectionStyle.None;
            }
        }
        cell?.textLabel?.text = _infoDict[String(section)]!["Name"] as? String;
        
        if (self._cellInfo?.multChoose == true)
        {
            var switchOn  = false;
            if(_chooseList.contains(section))
            {
                switchOn = true;
            }
            let mySwitch = (cell?.accessoryView as! NSwitch);
            mySwitch.setOn(switchOn, animated: false);
            mySwitch.index = section;
        }
        return cell!;
    }
    
    func stateChanged(switchState: NSwitch) {
        let index  = switchState.index
        if switchState.on {
            if (_chooseList.contains(switchState.index) == false)
            {
                _chooseList.append(index);
            }
        } else {
            if (_chooseList.contains(index) == true)
            {
                _chooseList.removeAtIndex(_chooseList.indexOf(index)!)
            }
        }
        _chooseList.sortInPlace();
        _cellInfo.typeValue = _chooseList;
    }
}

class NSwitch: UISwitch {
    var index  = 0
}

