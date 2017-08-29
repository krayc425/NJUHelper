//
//  LoginCaptchaTableViewCell.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/8/27.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import Kingfisher

class LoginCaptchaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var captchaLabel: UILabel!
    @IBOutlet weak var captchaText: UITextField!
    @IBOutlet weak var captchaButton: UIButton!
    
    let url = URL(string: "http://elite.nju.edu.cn/jiaowu/ValidateCode.jsp")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        captchaLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 15.0)
        captchaLabel.textColor = UIColor.gray
        captchaLabel.sizeToFit()
        
        captchaText.font = UIFont.init(name: "PingFangSC-Regular", size: 15.0)
        
        refreshCaptcha()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func refreshCaptcha() {
        self.captchaButton.kf.setBackgroundImage(with: url,
                                                   for: .normal,
                                                   placeholder: nil,
                                                   options: [.forceRefresh],
                                                   progressBlock: nil,
                                                   completionHandler: nil)
    }
    
}
