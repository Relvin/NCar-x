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

class FTPNet:NSObject {
    private let _userName : String = "saic";
    private let _password : String = "Pass1234";
    private let _Url : String = "363600.cicp.net";
    private let _path : String = "ProjectTeamData/MobileData"
    override init (){
        super.init();
        
    }
    static let sharedInstance = FTPNet()
    
    
}
