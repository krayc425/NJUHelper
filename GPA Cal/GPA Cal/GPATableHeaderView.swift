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
    
    override func draw(_ rect: CGRect) {
        termTitleLabel.font = UIFont.init(name: "PingFangSC-SemiBold", size: 15.0);
        gpaLabel.font = UIFont.init(name: "PingFangSC-Light", size: 35.0)
        termTitleLabel.sizeToFit()
        gpaLabel.sizeToFit()
    }
    
    class func instanceFromNib() -> GPATableHeaderView {
        return UINib(nibName: "GPATableHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GPATableHeaderView
    }

}
