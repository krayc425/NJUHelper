//
//  LoginTableViewCell.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/9.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

class LoginTableViewCell: UITableViewCell {
    
    @IBOutlet weak var loginLabel: UILabel?
    @IBOutlet weak var loginText: UITextField?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Label
        loginLabel?.font = UIFont.init(name: "PingFangSC-Regular", size: 15.0);
        loginLabel?.textColor = UIColor.gray
        loginLabel?.sizeToFit()
        
        //Text
        loginText?.font = UIFont.init(name: "PingFangSC-Regular", size: 15.0);
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
