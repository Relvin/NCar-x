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

class NHomeController:  UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var _textField: UITextField!
    @IBOutlet weak var _nameLabel: UILabel!
    @IBOutlet weak var _unitLabel: UILabel!
    
    @IBOutlet var rootView: UIView!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    var selectedIndex: NSIndexPath!
    
    var isOpen = false;
    
    var _curTableViewCell: UITableViewCell!
    
    var _homeData : ComponentModel!
    var _selectFieldCell : NTableViewCell!
    var _firstLoad : Bool = true;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        _homeData = CarMainModel.sharedInstance.getComponentInfo();
        
        _tableView.reloadData();

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(NHomeController.keyboardHide(_:)) );
        
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView(_tableView, didSelectRowAtIndexPath: indexPath);
        
    }
    
    override func updateViewConstraints (){
        super.updateViewConstraints();
        
        _homeData = CarMainModel.sharedInstance.getComponentInfo();
        _tableView.reloadData();
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
//        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath);
//        return cell.frame.size.height;
        
        var row = 0;
        if (selectedIndex != nil){
            row = selectedIndex.section
        }
        if (selectedIndex != nil && indexPath.section == selectedIndex.section ) {
            if (isOpen == true) {
                
                let f:CGFloat = 50.0;
                
                if (indexPath.row == _homeData.count - 1){
                    
                    return 153.8+(f - 21);
                }
                
                return 155+(f - 21);
                
            }else{
                
                return 67;
            }
            
        }
        return 67;
        
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
            let cell = _tableView.cellForRowAtIndexPath(indexPath);
            _nameLabel.text = cell?.textLabel?.text;
            let unit = cellData.unit;
            _textField.text = cellData.value;
            _unitLabel.text = unit;
            if (unit == "")
            {
                _textField.keyboardType = UIKeyboardType.ASCIICapable;
            }
            else{
                _textField.keyboardType = UIKeyboardType.NumberPad;
            }
            _selectFieldCell = (cell as? NTableViewCell);
            if (_firstLoad == false)
            {
                _textField.becomeFirstResponder()
            }
            _firstLoad = false;
            break;
        case .addSizeCell:
            
            //记下选中的索引

            var indexPaths:[NSIndexPath] = [indexPath];
            if (self.selectedIndex != nil && indexPath.section == selectedIndex.section) {
                isOpen = !isOpen;
//                NSArray
                
                indexPaths.append(selectedIndex);
                
            }else if (self.selectedIndex != nil && indexPath.section != selectedIndex.section) {
            
                indexPaths.append(selectedIndex);
                isOpen = true;
            }
            if (self.selectedIndex == nil)
            {
                isOpen = true;
            }
            //记下选中的索引
            self.selectedIndex = indexPath;
            

            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade);
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
            cell = tableView.dequeueReusableCellWithIdentifier("switch");
            if (cell == nil){
                cell = NSBundle.mainBundle().loadNibNamed("SwitchCell", owner: nil, options: nil).first as? SwitchCell
                
                cell?.frame = CGRect(x: 0, y: 0, width: self._tableView.frame.width, height: cell.frame.height)
                cell?.center = self._tableView.center
                let mySwitch = UISwitch();
                mySwitch.addTarget(self, action: #selector(NHomeController.stateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)

                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
            break;
        case .packageCell:
            cell = tableView.dequeueReusableCellWithIdentifier("pick");
            if (cell == nil){
                cell = NTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "pick");
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
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
        
        (cell as! NTableViewCell).setCellInfo(cellData!);
        
//        cell!.textLabel!.text = cellLabel[section];
        
        
        
        
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
        (sender as! UITextField).text = "";
    }

    @IBAction func editingDidEnd(sender: AnyObject) {
        var inputStr = (sender as! UITextField).text;
        
        if ((_selectFieldCell) != nil)
        {
            
            let partData = CarMainModel.sharedInstance.getComponentInfo().getPartById(_selectFieldCell.index)
            if (inputStr == "" && partData.unit != "")
            {
                inputStr = "0";
            }
            
            partData.value = inputStr!;
            _selectFieldCell.detailTextLabel?.text = inputStr! + partData.unit;
        }
        
        
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
    var _cellInfo : subComponentModel?
    var _infoDict : NSDictionary!;
    
    init(cellInfo : subComponentModel?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self._cellInfo = cellInfo!;
        _infoDict = CarMainModel.sharedInstance.getConfigInfoByName((cellInfo?.subForm)!);
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return _infoDict.count;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let section = indexPath.section;
        _cellInfo?.typeValue = [section];
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let section = indexPath.section;
        var cell = tableView.dequeueReusableCellWithIdentifier("textField");
        if (cell == nil){
            cell = NTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "textField");
            
        }
        cell?.textLabel?.text = _infoDict[String(section)]!["Name"] as? String;
        return cell!;
    }
}


