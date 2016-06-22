//
//  SwitchCell.swift
//  NCar-X
//
//  Created by Relvin on 16/6/17.
//  Copyright © 2016年 Relvin. All rights reserved.
//

import UIKit

class NTableViewCell: UITableViewCell {
    
    var index : Int = 0
    
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
        index = cellInfo.id
    
    }
}

class SwitchCell: NTableViewCell {

    @IBOutlet weak var _nameLabel: UILabel!
    
    @IBOutlet weak var _detalSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setCellInfo(cellInfo : subComponentModel) {
        self._nameLabel.text = cellInfo.name;
    }
    
}
