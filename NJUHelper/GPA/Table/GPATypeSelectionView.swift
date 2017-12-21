//
//  GPATypeSelectionView.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/8.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

protocol TypeSelectionDelegate: class {
    func didSelectType(courseType: courseType, isAdding: Bool);
}

class GPATypeSelectionView: UIView {

    private var view: UIView?
    
    @IBOutlet weak var typeStack: UIStackView! {
        didSet {
            for view in typeStack.subviews {
                let button = view as! UIButton
                button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14.0);
                button.setTitleColor(UIColor.white, for: UIControlState.normal)
                button.layer.cornerRadius = 5.0
                button.layer.masksToBounds = true
                button.layer.borderColor = UIColor.clear.cgColor
                button.layer.borderWidth = 1.0
                
                button.setTitle(courseTypeList[button.tag].rawValue, for: UIControlState.normal)
                button.backgroundColor = courseTypeList[button.tag].backgroundColor
            }
        }
    }
    var selectedType = NSMutableArray(capacity: 5)
    var delegate: TypeSelectionDelegate?       //代理
    
    @IBOutlet var contentView: GPATypeSelectionView!
    
    let courseTypeList = [
        courseType.通识,
        courseType.通修,
        courseType.公共,
        courseType.选修,
        courseType.平台,
        courseType.核心
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        if selectedType.contains(sender.tag) {
            selectedType.remove(sender.tag)
            sender.backgroundColor = self.courseTypeList[sender.tag].backgroundColor
            sender.setTitleColor(UIColor.white, for: UIControlState.normal)
            sender.layer.borderColor = UIColor.clear.cgColor
            
            self.delegate?.didSelectType(courseType: courseTypeList[sender.tag], isAdding: false)
        } else {
            selectedType.add(sender.tag)
            sender.setTitleColor(self.courseTypeList[sender.tag].backgroundColor, for: UIControlState.normal)
            sender.backgroundColor = UIColor.white
            sender.layer.borderColor = sender.titleColor(for: UIControlState.normal)?.cgColor
            
            self.delegate?.didSelectType(courseType: courseTypeList[sender.tag], isAdding: true)
        }
    }
    
    // MARK: - Private Helper Methods
    
    // Performs the initial setup.
    private func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        
        // Auto-layout stuff.
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        // Show the view.
        addSubview(view)
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
}
