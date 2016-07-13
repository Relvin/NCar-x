//
//  CarMainModel.swift
//  NCar-X
//
//  Created by Relvin on 16/6/19.
//  Copyright © 2016年 Relvin. All rights reserved.
//

import Foundation


public enum subComponentType: Int {
    case textFieldCell = 0
    case addSizeCell = 1
    case packageCell = 2
    case materialTextureCell = 3
    case craftRecommendCell = 4
    case contentCell = 5
    case dataCheck = 6
}

//let _SingletonSharedInstance = CarMainModel()


class CarMainModel
    : NSObject
{
    private var _componentModel : ComponentModel!;
    private var _configDict : [String : AnyObject] = [:];
    
    static let sharedInstance = CarMainModel()
    
    override init (){
        super.init();
        self.loadConfig();
        _componentModel = ComponentModel(info: (_configDict["partsParam"] as? NSDictionary)!);
        
    }
    
    func getComponentInfo() -> ComponentModel {
        return _componentModel;
    }
    
    func loadConfig() {
        let config = self.loadConfig("partsParam");
        if (config != nil){
            self._configDict["partsParam"] = config;
            for (_,value) in config! {
                let subForm = value["SubForm"] as? String
                if (subForm != nil)
                {
                    let subConf = self.loadConfig(subForm!);
                    if (subConf != nil)
                    {
                        self._configDict[subForm!] = subConf;
                    }
                }
                let additional = value["AdditionalForm"] as? String
                if (additional != nil)
                {
                    let additionalConf = self.loadConfig(additional!);
                    if (additionalConf != nil)
                    {
                        self._configDict[additional!] = additionalConf;
                    }
                }
            }
        }
        
    }
    
    func loadConfig(fileName:String)-> [String : AnyObject]? {
        if let file = NSBundle(forClass:ComponentModel.self).pathForResource("config/" + fileName, ofType: "json") {
            let testData = NSData(contentsOfFile: file)
            let json = JSON(data:testData!)
            return parserJson(json) as? [String : AnyObject];
            
            
        } else {
            print("Can't find the test JSON file = " + fileName)
            return nil;
        }
        
    }
    
    func getConfigInfoByName(name:String) ->[String: AnyObject] {
        return self._configDict[name] as! [String : AnyObject]
    }
    
    func parserJson (json:JSON) -> AnyObject{
        switch json.type {
        
        case .Dictionary:
            var rawDictionary: [String : AnyObject] = [:]
            for (key,value) in json
            {
                let ret  = self.parserJson(value);
                if ((ret as? NSNull) == nil)
                {
                    rawDictionary[key] = ret;
                }
            }
            if (rawDictionary.count > 0)
            {
                return rawDictionary;
            }
            else{
                return NSNull();
            }
        
        default:
            return json.object
            
        }

    }
    
}

class ComponentModel: NSObject {
    var parts : [Int : subComponentModel] = [:]
    init (info : NSDictionary) {
        super.init();
        for (key,value) in info{
            parts[Int(key as! String)!] = subComponentModel(info: value as! NSDictionary);
        }
//        print (value)
//        print value
    }
    
    var count : Int {
        return parts.count
    }
    
    func getPartById(id : Int) -> subComponentModel! {
        if (id >= parts.count)
        {
            return nil;
        }
        return parts[id];
    }
    
    
}


class subComponentModel: NSObject {
    var id : Int = 0
    var name : String = ""
    var type : subComponentType = .textFieldCell
    var value : String = ""
    var unit : String = ""
    var typeValue : [Int] = [0]
    var force : Bool = false
    var open : Bool = false
    var subForm : String = ""
    var additionalForm : String = ""
    var multChoose : Bool = false
    var content : String = ""
    var additional : [Int : String] = [:]
    
    init(info: NSDictionary) {
        super.init();
        id = info["ID"] as! Int;
        name = info["Name"] as! String;
        type = subComponentType(rawValue: Int(info["Type"] as! String)!)!;
        let subForm = info["SubForm"] as? String
        if (subForm != nil){
            self.subForm = subForm!;
        }
        
        let additionalForm = info["AdditionalForm"] as? String
        if (additionalForm != nil){
            self.additionalForm = additionalForm!;
            let additionalList : [Int] = info["AdditionalValue"] as! Array;
            
            for value in additionalList
            {
                additional[value] = "";
            }
            
        }
        
        let unit = info["Unit"] as? String
        if (unit != nil){
            self.unit = unit!;
            value = "0"
        }
        
        
        if ((info["MultChoose"] as? String) == "1"){
            self.multChoose = true
        }
        
    }
    
    func getAdditionalCount() -> Int{
        return additional.count
    }
    
    func getAdditionalValueById(id : Int) -> String {
        return additional[id]!;
    }
    
    func getAdditionalIdByIndex(index : Int) ->Int {
        var keysList : [Int] = (additional as NSDictionary).allKeys as! [Int];
        keysList.sortInPlace();
        
        return keysList[index];
    }
    
    func getAdditionalNameById(id : Int) -> String {
        var addtionalConf = CarMainModel.sharedInstance.getConfigInfoByName(additionalForm);
        if (addtionalConf.count > id)
        {
            return (addtionalConf[String(id)]!["Name"] as? String)!;
        }
        return "";
        
    }
    
    func getAdditionalUnitById(id : Int) -> String {
        var addtionalConf = CarMainModel.sharedInstance.getConfigInfoByName(additionalForm);
        if (addtionalConf.count > id)
        {
            return (addtionalConf[String(id)]!["Unit"] as? String)!;
        }
        return "";
        
    }

    func setAdditionalValueById(id : Int,value : String) {
        self.additional.updateValue(value, forKey: id);
    }
    
}

class partsConfig : NSObject {
    var id : Int!
    var name : String!
    var type : subComponentType!
    var unit : String!
    var force : Bool!
    var chooseValue : [String]!
    
}


