//
//  FTPNet.swift
//  NCar-X
//
//  Created by Relvin on 16/7/10.
//  Copyright © 2016年 Relvin. All rights reserved.
//

import Foundation
import RebekkaTouch

//let _SingletonSharedInstance = CarMainModel()

public typealias LoginResultCompletionHandler = (Bool, NSError?) -> Void

class FTPNet:NetBase {
    private let _userName : String = "saic";
    private let _password : String = "Pass1234";
    private let _host : String = "ftp://363600.cicp.net"; //"ftp://saic:Pass1234@363600.cicp.net"//
    private let _path : String = "/ProjectTeamData/MobileData/";
    private var _session : Session!;
    private var _userPath = "tmp/"
    override init (){
        super.init();
        
        var configuration = SessionConfiguration()
        configuration.username = _userName;
        configuration.password = _password;
        configuration.host = _host
        self._session = Session(configuration: configuration)
//        self.testList();
    }
    static let sharedInstance = FTPNet()
    
    
    func testList() {
        self._session.list(_path) {
            (resources, error) -> Void in
            print("List directory with result:\n\(resources), error: \(error)\n\n")
        }
    }
    
    func login(userName : String,password:String,loginHandle :LoginResultCompletionHandler) {
        self._session.list(_path) {
            (resources, error) -> Void in
            if error == nil{
                for value in resources!{
                    if (value.name.rangeOfString(userName) != nil){
                        loginHandle(true,error);
                        self._userPath = value.name + "/"
                        if !self._userPath.hasSuffix("/") {
                            self._userPath = self._userPath + "/"
                        }
                        return;
                    }
                }
            }
            
            loginHandle(false,error);
            
        }
    }
    
    
    
    func createDir(dirName : String) {
        self._session.createDirectory(_path + dirName) {
            (result, error) -> Void in
            print("Create directory with result:\n\(result), error: \(error)")
        }
    }
    
    func uploadFile(filePath : String,loginHandle :LoginResultCompletionHandler) {
        let url = NSURL(fileURLWithPath: filePath);
        
        let range = (filePath as NSString).rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch);
        let fileName = (filePath as NSString).substringFromIndex(range.location + 1);
        
        let path = _path + _userPath + fileName;
        self._session.upload(url, path: path) {
            (result, error) -> Void in
            print("Upload file with result:\n\(result), error: \(error)\n\n")
        }
        
    }
    
    
    func downloadFile(fileName : String) {
//        self.session.download("/1MB.zip") {
//            (fileURL, error) -> Void in
//            print("Download file with result:\n\(fileURL), error: \(error)\n\n")
//            if let fileURL = fileURL {
//                do {
//                    try NSFileManager.defaultManager().removeItemAtURL(fileURL)
//                } catch let error as NSError {
//                    print("Error: \(error)")
//                }
//                
//            }
//        }
    }
    
    
    
}
