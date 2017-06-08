//
//  GPATableViewCell.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import AIFlatSwitch

protocol GPATableViewCellDelegate {

    func didSelectGPACell(cell: GPATableViewCell?);
    func didDeselectGPACell(cell: GPATableViewCell?);
    
}

class GPATableViewCell: UITableViewCell {
    
    @IBOutlet var chineseNameLabel: UILabel!
    @IBOutlet var englishNameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var creditLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    var checkBox: AIFlatSwitch!
    
    var delegate: GPATableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chineseNameLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 18.0);
        englishNameLabel.font = UIFont.init(name: "PingFangSC-Light", size: 15.0);
        typeLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 13.0);
        creditLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 13.0);
        scoreLabel.font = UIFont.init(name: "PingFangSC-Light", size: 32.0);
        
        typeLabel.layer.cornerRadius = 5.0
        typeLabel.layer.masksToBounds = true
        creditLabel.layer.cornerRadius = 5.0
        creditLabel.layer.masksToBounds = true
        
        typeLabel.textColor = UIColor.white
        
        checkBox = AIFlatSwitch(frame: CGRect.init(x: 18, y: 10, width: 20, height: 20))
        checkBox.addTarget(self, action: #selector(handleSwitchValueChange(sender:)), for: UIControlEvents.valueChanged)
        checkBox.lineWidth = 1.0
        self.addSubview(checkBox)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func handleSwitchValueChange(sender: AnyObject) {
        if sender is AIFlatSwitch {
            if(sender.isSelected){
                self.delegate.didSelectGPACell(cell: self)
            }else{
                self.delegate.didDeselectGPACell(cell: self)
            }
        }
    }
    
    func setSwitchValue(isSelected: Bool, animated: Bool) {
        checkBox.setSelected(isSelected, animated: animated)
    }
    
}
