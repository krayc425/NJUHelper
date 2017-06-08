//
//  GPATypeSelectionView.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/8.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

protocol TypeSelectionDelegate {
    
    func didSelectType(courseType: courseType, isAdding: Bool);
    
}

class GPATypeSelectionView: UIView {

    @IBOutlet var typeStack: UIStackView!
    var selectedType: NSMutableArray!
    var delegate: TypeSelectionDelegate?       //代理
    
    let courseTypeList = [
        courseType.通识,
        courseType.通修,
        courseType.公共,
        courseType.选修,
        courseType.平台,
        courseType.核心
    ]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selectedType = NSMutableArray(capacity: 5)
    }
    
    override func awakeFromNib() {
        for view in typeStack.subviews{
            let label = view as! UIButton
            label.titleLabel?.font = UIFont.init(name: "PingFangSC-Regular", size: 14.0);
            label.setTitleColor(UIColor.white, for: UIControlState.normal)
            label.layer.cornerRadius = 5.0
            label.layer.masksToBounds = true
            label.layer.borderColor = UIColor.clear.cgColor
            label.layer.borderWidth = 1.0
            
            label.setTitle(courseTypeList[label.tag].rawValue, for: UIControlState.normal)
            label.backgroundColor = courseTypeList[label.tag].backgroundColor
            label.addTarget(self, action: #selector(buttonAction(sender:)), for: UIControlEvents.touchUpInside)
        }
    }
    
    func buttonAction(sender: UIButton) -> () {
        if selectedType.contains(sender.tag) {
            selectedType.remove(sender.tag)
            sender.backgroundColor = self.courseTypeList[sender.tag].backgroundColor
            sender.setTitleColor(UIColor.white, for: UIControlState.normal)
            sender.layer.borderColor = UIColor.clear.cgColor
            
            self.delegate?.didSelectType(courseType: courseTypeList[sender.tag], isAdding: false)
        }else{
            selectedType.add(sender.tag)
            sender.setTitleColor(self.courseTypeList[sender.tag].backgroundColor, for: UIControlState.normal)
            sender.backgroundColor = UIColor.white
            sender.layer.borderColor = sender.titleColor(for: UIControlState.normal)?.cgColor
            
            self.delegate?.didSelectType(courseType: courseTypeList[sender.tag], isAdding: true)
        }
    }
    
    class func instanceFromNib() -> GPATypeSelectionView {
        return UINib(nibName: "GPATypeSelectionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GPATypeSelectionView
    }
    
}
