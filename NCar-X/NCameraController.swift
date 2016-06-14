//
//  NCameraController.swift
//  NCar-X
//
//  Created by Relvin on 16/6/14.
//  Copyright © 2016年 Relvin. All rights reserved.
//

import UIKit


class NCameraController:  UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet var _cameraView: UIView!
    @IBOutlet weak var imagea: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagePicker = UIImagePickerController();
        imagePicker.delegate = self
        var sourceType = UIImagePickerControllerSourceType.Camera;
        if (!UIImagePickerController.isSourceTypeAvailable(sourceType))
        {
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        }
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true;
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        self.dismissViewControllerAnimated(true, completion: nil)
//        print(info)
        self.imagea.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
}