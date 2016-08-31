//
//  NCameraController.swift
//  NCar-X
//
//  Created by Relvin on 16/6/14.
//  Copyright © 2016年 Relvin. All rights reserved.
//

import UIKit

private var cellContentMask = 1101;
private var cellPerCount = 3;
private var cellWidth = 80;

extension UIImage{
    static func getImageWithScale(image : UIImage! ,asize : CGSize) -> UIImage {
        var newimage : UIImage!;
        if (nil == image) {
            newimage = nil;
        }
        else{
            let oldsize = image.size;
            var rect : CGRect = CGRect(x: 0,y: 0,width: 0,height: 0);
            if (asize.width/asize.height > oldsize.width/oldsize.height) {
                rect.size.width = asize.height*oldsize.width/oldsize.height;
                rect.size.height = asize.height;
                rect.origin.x = (asize.width - rect.size.width)/2;
                rect.origin.y = 0;
            }
            else{
                rect.size.width = asize.width;
                rect.size.height = asize.width*oldsize.height/oldsize.width;
                rect.origin.x = 0;
                rect.origin.y = (asize.height - rect.size.height)/2;
            }
            
            UIGraphicsBeginImageContext(asize);
            let context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor);
            UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
            image.drawInRect(rect);
            newimage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        return newimage;
    }
}


class NCameraController:  UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,LGImagePickControllerDelegate,PassPhotosDelegate{


    @IBOutlet weak var _cameraButton: UIButton!
    @IBOutlet weak var _photoButton: UIButton!
    
    @IBOutlet weak var _touchView: UIControl!
    @IBOutlet weak var _imageView: UIImageView!
    @IBOutlet weak var _tableContainer: UIView!
    private var _imageList: [UIImage] = []
    private var _photoList: [UIImage] = []
    private var _cameraList:[UIImage] = []
    private var _tableView: UITableView!
    private var _imagePath: [String] = []
    private var _cameraPath: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _tableView = UITableView(frame:CGRect(x: 0,y: 0,width: 0,height: 0),style: UITableViewStyle.Plain);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableContainer.addSubview(_tableView);
        _tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        _tableView.backgroundColor = UIColor.clearColor();
        _touchView.hidden = true;
    }
    
    override func viewDidAppear(animated: Bool) {
        _imageList.removeAll();
        _imageList += _cameraList;
        _imageList += _photoList;
        let frame = _tableContainer.frame;
        _tableView.frame = CGRect(x: 0,y: 0,width: frame.width,height: frame.height);
        _tableView.reloadData();
        
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
        let component = CarMainModel.sharedInstance.getComponentInfo();
        component.images.removeAll();
        component.images += _cameraPath;
        component.images += _imagePath;
        
    }
    
    func passPhotos(selected:[ZuberImage])  {
        _photoList.removeAll()
        for zuberImage in selected
        {
           let uiImage = UIImage(CGImage: zuberImage.asset.aspectRatioThumbnail().takeUnretainedValue())
            self.saveImage(uiImage);
            _photoList.append(uiImage)
        }
    }
    
    @IBAction func touchUpOutSide(sender: UIButton) {
        
        if (sender == _photoButton)
        {
            
            let imagePick = LGImagePickController()
            imagePick.delegate = self
            let nav = UINavigationController(rootViewController: imagePick)
            self.presentViewController(nav, animated: true, completion: nil)
            
//            let imageChoose = ImageChooseController(nibName: "ImageChoose",bundle: nil);
//            imageChoose.photoDelegate = self
//            self.navigationController?.pushViewController(imageChoose, animated: true);
        }
        else{
            let imagePicker = UIImagePickerController();
            imagePicker.delegate = self
            if (_cameraButton == sender && UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            }
            else{
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            }
            
            
            imagePicker.view.frame = CGRect(x: 0,y: 0,width: 400,height: 400);
            imagePicker.allowsEditing = true;
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        self.dismissViewControllerAnimated(true, completion: nil)
        let uiimage = info[UIImagePickerControllerEditedImage] as! UIImage;
        let imageName = self.saveImage(uiimage);
        UIImageWriteToSavedPhotosAlbum(uiimage, nil, nil, nil);
        _cameraList.append(uiimage);
        self._cameraPath.append(imageName);
        
    }
    
    func saveImage(image : UIImage) -> String{
        let component = CarMainModel.sharedInstance.getComponentInfo();
        let savePath = component.getSavePath();
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd_HH_mm_ss_SSS" //(格式可俺按自己需求修整)
        let strNowTime = timeFormatter.stringFromDate(date) as String
        let data = UIImagePNGRepresentation(image);
        let imageName = strNowTime + ".png";
        try! data!.writeToFile(savePath + imageName, options: NSDataWritingOptions.AtomicWrite)
        return imageName;
     }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return Int(ceilf(Float(_imageList.count) / Float(cellPerCount)));
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return CGFloat(cellWidth);
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("imageCell") as? ImageCell;
        if (cell == nil){
            cell = ImageCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "imageCell");
            cell!.addTarget(self, action: #selector(NCameraController.cellImageTouchCallback(_:)));
            cell?.frame = CGRect(x: 0, y: 0, width: self._tableView.frame.width, height: cell!.frame.height)
            cell?.center = self._tableView.center
            cell?.updateImagePosition();
            
        }
        let section = indexPath.section;
        cell!.setIndexValue(section);
        for idx in 0 ..< cellPerCount
        {
            let imageButton = cell!.contentView.viewWithTag(idx + cellContentMask)
            let index = section * cellPerCount + idx;
            if (_imageList.count > index)
            {
                imageButton?.hidden = false;
                imageButton?.backgroundColor = UIColor(patternImage: UIImage.getImageWithScale(_imageList[index],asize: CGSize(width: cellWidth,height: cellWidth)));
            }
            else
            {
                imageButton?.hidden = true
            }
        }
        return cell!;
    }
    
    func cellImageTouchCallback(cell : ImageCell!) {
        let index = cell.getTouchIndex();
        _touchView.hidden = false;
        _imageView.image = self._imageList[index]
    }
    
    @IBAction func touchUpInside(sender: AnyObject) {
        _touchView.hidden = true;
    }
    
    func imagePickerController(picker: LGImagePickController, didFinishPickingImages images: [UIImage])
    {
        self._imagePath.removeAll();
        for uiImage in images
        {
            let imageName = self.saveImage(uiImage);
            _photoList.append(uiImage)
            self._imagePath.append(imageName);
        }

    }
    func imagePickerControllerCanceled(picker: LGImagePickController)
    {
        self._imagePath.removeAll();
    }
    
}

class ImageCell: UITableViewCell {
    var index = 0
    private var _target : NSObject!
    private var _action : Selector!
    var touchIndex = 0
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        for idx in 0 ..< cellPerCount
        {
            let imageButton = UIButton();
            self.contentView.addSubview(imageButton);
            imageButton.tag = idx + cellContentMask;
            imageButton.frame = CGRect(x: idx * (cellWidth + 20) + 20,y: 0,width: cellWidth,height: cellWidth);
            imageButton.addTarget(self, action: #selector(ImageCell.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateImagePosition() {
        let delta = (self.frame.width - CGFloat(cellPerCount * cellWidth)) / CGFloat(cellPerCount + 1)
        for idx in 0 ..< cellPerCount
        {
            let imageButton = self.contentView.viewWithTag(idx + cellContentMask);
            imageButton!.frame = CGRect(x: CGFloat(idx) * (CGFloat(cellWidth) + delta) + delta,y: 0,width: CGFloat(cellWidth),height: CGFloat(cellWidth));
        }
    }
    
    func addTarget(target: NSObject?, action: Selector)
    {
        self._action = action;
        self._target = target;
    }
    
    func buttonClicked(button : UIButton!) {
        let tag = button.tag;
        self.touchIndex = index * cellPerCount + (tag - cellContentMask);
        self._target.performSelector(self._action, withObject:self , afterDelay: 0)
    }
    
    func setIndexValue(index : Int) {
        self.index = index;
    }
    
    func getTouchIndex() -> Int {
        return self.touchIndex;
    }
    
}

