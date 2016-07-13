//
//  NHomeController.swift
//  NCar-X
//
//  Created by Relvin on 16/6/13.
//  Copyright © 2016年 Relvin. All rights reserved.
//  Relvin.NCar-X

import UIKit

class NHomeController:  UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CellDelegateProtocol{
    
    @IBOutlet weak var _inputView: UIView!
    @IBOutlet weak var _tableContainer: UIView!
    @IBOutlet weak var touchView: UIControl!
    var _tableView: UITableView!
    @IBOutlet weak var _textField: UITextField!
    @IBOutlet weak var _nameLabel: UILabel!
    @IBOutlet weak var _unitLabel: UILabel!
    
    @IBOutlet var rootView: UIView!
    
    var selectedIndex: Int = 0
    var subIndex: Int = -1
    
    var isOpen = false;
    
    var _curTableViewCell: UITableViewCell!
    
    var _homeData : ComponentModel!

    var _firstLoad : Bool = true;
    
    var _defalutFontName : String = ""
    var _defalutFontSize : CGFloat = 14
    var keyboardShow : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad();
        touchView.hidden = true;
        self.automaticallyAdjustsScrollViewInsets = false;
        _homeData = CarMainModel.sharedInstance.getComponentInfo();
        
        _defalutFontName = (_textField.font?.fontName)!;
        _defalutFontSize = (_textField.font?.lineHeight)!;
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(NHomeController.refreshLayer),
                                                         name: "SwitchChange", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NHomeController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(NHomeController.textDidBeginEditing),
                                                         name: UITextViewTextDidBeginEditingNotification, object: nil)
        _tableView = UITableView(frame:CGRect(x: 0,y: 0,width: 0,height: 0),style: UITableViewStyle.Plain);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableContainer.addSubview(_tableView);
        _tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        
        _tableView.backgroundColor = UIColor.clearColor();
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView(_tableView, didSelectRowAtIndexPath: indexPath);
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!);
    }
    
    override func viewDidAppear(animated: Bool) {
        let frame = _tableContainer.frame;
        let inputFrame = _inputView.frame;
        _tableView.frame = CGRect(x: 0,y: inputFrame.height,width: frame.width,height: frame.height - inputFrame.height);
        self.refreshLayer();
    }
    
    func refreshLayer() {
        _homeData = CarMainModel.sharedInstance.getComponentInfo();
        _tableView.reloadData();
    }
    
    func textDidBeginEditing(pSender: AnyObject) {
//        self.animateTextField(offset);
    }
    func keyboardWillShow(aNotification: NSNotification) {
        
        let userinfo: NSDictionary = aNotification.userInfo!
        let nsValue = userinfo.objectForKey(UIKeyboardFrameEndUserInfoKey)
        let keyboardRec = nsValue?.CGRectValue()
        let height = keyboardRec?.size.height
        
        
        var offset = height!;
        if (touchView.hidden == false)
        {
            let indexPath = NSIndexPath(forRow: 0, inSection: selectedIndex)
            let rectIntable = _tableView.rectForRowAtIndexPath(indexPath);
            let rect = _tableView.convertRect(rectIntable, toView: self.view);
            
            offset -= (self.view.frame.height - rect.origin.y - rect.height);
        }
        else{
            touchView.hidden = false;
            offset -= 50;
        }
        
        self.animateTextField(offset);

    }
    func animateTextField(yOffset : CGFloat) {
        
        if (yOffset >= 0)
        {
            let orgRect = _tableView.frame;
            UIView.beginAnimations("Animation", context: nil);
            UIView.setAnimationBeginsFromCurrentState(true);
            UIView.setAnimationDuration(0.5);
            
            _tableView.frame = CGRect(x: orgRect.origin.x,y: -yOffset,width: orgRect.width,height: orgRect.height);
            
            UIView.commitAnimations();
            
        }
    }
    
    func cellTableTouched(cellInfo:subComponentModel ,subIndex : Int)
    {
        selectedIndex = cellInfo.id
        self.subIndex = subIndex;
        
        var unit = ""
        var text = "";
        if (subIndex != -1)
        {
            
            let subId = cellInfo.getAdditionalIdByIndex(subIndex);
            unit = cellInfo.getAdditionalUnitById(subId);
            text = cellInfo.getAdditionalValueById(subId);
            _unitLabel.text = unit;
            _nameLabel.text = cellInfo.getAdditionalNameById(subId);
        }
        else
        {
            unit = cellInfo.unit;
            text = cellInfo.value;
            _unitLabel.text = unit;
            _nameLabel.text = cellInfo.name;
        }
        
        if (unit == "")
        {
            _textField.keyboardType = UIKeyboardType.ASCIICapable;
            _textField.font = UIFont(name: "",size: _defalutFontSize);
            _textField.placeholder = "INPUT"
        }
        else{
            _textField.keyboardType = UIKeyboardType.DecimalPad;
            _textField.font = UIFont(name : _defalutFontName,size: _defalutFontSize + 1);
            _textField.placeholder = "0"
        }
        
        
        if (_firstLoad == false)
        {
            touchView.hidden = false;
            _textField.becomeFirstResponder()
        }
        if (text != "0")
        {
            _textField.text = text;
        }
        
        _firstLoad = false;
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as! NTableViewCell;
        
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
                cell.backgroundView = UIImageView(image: UIImage(named: "cellNormal.png"));
                cell.backgroundColor = UIColor.clearColor()
            }
            break;
        case .addSizeCell:
            cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell");
            if (cell == nil){
                cell = NSBundle.mainBundle().loadNibNamed("SwitchCell", owner: nil, options: nil).first as? SwitchCell
                
                cell?.frame = CGRect(x: 0, y: 0, width: self._tableView.frame.width, height: cell.frame.height)
                cell?.center = self._tableView.center
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.backgroundColor = UIColor.clearColor()
            }
            break;
        case .packageCell:
            cell = tableView.dequeueReusableCellWithIdentifier("PackageCell");
            if (cell == nil){
                cell =   NSBundle.mainBundle().loadNibNamed("PackageCell", owner: nil, options: nil).first as? PackageCell
                cell?.frame = CGRect(x: 0, y: 0, width: self._tableView.frame.width, height: cell.frame.height)
                cell?.center = self._tableView.center
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.backgroundColor = UIColor.clearColor()
            }
            break;
        case .materialTextureCell:
            cell = tableView.dequeueReusableCellWithIdentifier("pick");
            if (cell == nil){
                cell = NTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "pick");
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.backgroundView = UIImageView(image: UIImage(named: "cellNormal.png"));
                cell.backgroundColor = UIColor.clearColor()
            }
            break;
            
        case .craftRecommendCell:
            cell = tableView.dequeueReusableCellWithIdentifier("craftRecommendCell");
            if (cell == nil){
                cell =   NSBundle.mainBundle().loadNibNamed("craftRecommendCell", owner: nil, options: nil).first as? craftRecommendCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.backgroundView = UIImageView(image: UIImage(named: "cellNormal.png"));
                cell.backgroundColor = UIColor.clearColor()
            }
            break;
        case .contentCell:
            cell = tableView.dequeueReusableCellWithIdentifier("ContentCell");
            if (cell == nil){
                cell =   NSBundle.mainBundle().loadNibNamed("ContentCell", owner: nil, options: nil).first as? ContentCell
                cell?.frame = CGRect(x: 0, y: 0, width: self._tableView.frame.width, height: cell.frame.height)
                cell?.center = self._tableView.center
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.backgroundView = UIImageView(image: UIImage(named: "cellNormal.png"));
                cell.backgroundColor = UIColor.clearColor()
            }
            break;
        case .dataCheck:
            cell = tableView.dequeueReusableCellWithIdentifier("switch");
            if (cell == nil){
                cell = NTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "switch");
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                let switchButton = UISwitch();
                cell.accessoryView = switchButton;
                cell.backgroundView = UIImageView(image: UIImage(named: "cellNormal.png"));
                cell.backgroundColor = UIColor.clearColor()
                switchButton.addTarget(self, action: #selector(NHomeController.switchButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            }
            let switchButton = cell.accessoryView as! UISwitch;
            switchButton.tag = section;
            switchButton.setOn(cellData.open, animated: false);
            break;
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("textField");
            if (cell == nil){
                cell = NTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "textField");
                let label = UILabel();
                cell!.accessoryView = label;
                cell.backgroundColor = UIColor.clearColor()
            }
                break;
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let ncell = (cell as! NTableViewCell)
        ncell.setCellInfo(cellData!);
        ncell.setCellDelegate(self);
        
        return cell!;
    }
    
    
    @IBAction func editingDidBegin(sender: AnyObject) {
        keyboardShow = true;
        (sender as! UITextField).text = "";
    }
    
    func switchButtonClicked(switchButton:UISwitch!) {
        let tag = switchButton.tag;
        let open = switchButton.on;
        let cellData = _homeData.getPartById(tag);
        cellData.open = open;
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
        
        
    }
    @IBAction func touchUpInside(sender: AnyObject) {
        self.view.endEditing(true);
        self.animateTextField(0);
        touchView.hidden = true;
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        keyboardShow = false;
        touchView.hidden = true;
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

