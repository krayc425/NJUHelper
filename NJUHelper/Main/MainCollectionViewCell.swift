//
//  MainCollectionViewCell.swift
//  NJUHelper
//
//  Created by 宋 奎熹 on 2017/12/20.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var corneredView: UIView?
    
    @IBOutlet weak var titleLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        corneredView?.layer.shadowRadius = 5.0
        corneredView?.layer.cornerRadius = 10.0
        corneredView?.layer.shadowOffset = CGSize(width: 0, height: 2)
        corneredView?.layer.shadowColor = UIColor.black.cgColor
        corneredView?.layer.shadowOpacity = 0.25
        corneredView?.clipsToBounds = false
        
        titleLabel?.textColor = .white
    }
    
}
