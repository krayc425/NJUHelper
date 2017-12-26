//
//  PNJUAutoTableViewCell.swift
//  NJUHelper
//
//  Created by 宋 奎熹 on 2017/12/26.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

class PNJUAutoTableViewCell: UITableViewCell {

    @IBOutlet weak var autoLabel: UILabel!
    @IBOutlet weak var autoSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        autoLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 15.0)
        autoLabel.textColor = UIColor.gray
        autoLabel.sizeToFit()
        
        autoSwitch.onTintColor = .pnju
        autoSwitch.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: .valueChanged)
        autoSwitch.setOn(PNJUHelper.shared.isAutoLogin(), animated: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc private func onSwitchValueChanged(_ sender: UISwitch) {
        PNJUHelper.shared.setAutoLogin(sender.isOn)
    }
    
}
