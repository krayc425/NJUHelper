//
//  GPATableHeaderView.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/7.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

class GPATableHeaderView: UIView {

    @IBOutlet var gpaLabel: UILabel!
    @IBOutlet var termTitleLabel: UILabel!
    @IBOutlet var courseNumLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        termTitleLabel.font = UIFont.init(name: "PingFangSC-SemiBold", size: 15.0);
        gpaLabel.font = UIFont.init(name: "PingFangSC-Light", size: 35.0)
        courseNumLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 12.0)
        courseNumLabel.textColor = UIColor.gray
        termTitleLabel.sizeToFit()
        gpaLabel.sizeToFit()
        courseNumLabel.sizeToFit()
    }
    
    class func instanceFromNib() -> GPATableHeaderView {
        return UINib(nibName: "GPATableHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GPATableHeaderView
    }

}
