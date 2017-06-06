//
//  GPATableViewCell.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

class GPATableViewCell: UITableViewCell {
    
    @IBOutlet var chineseNameLabel: UILabel!
    @IBOutlet var englishNameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var creditLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chineseNameLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 20.0);
        englishNameLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 15.0);
        typeLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 12.0);
        creditLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 12.0);
        scoreLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 30.0);
        
        typeLabel.layer.cornerRadius = 5.0
        creditLabel.layer.cornerRadius = 5.0
        
        typeLabel.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
