//
//  GPATableHeaderView.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/7.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

class GPATableHeaderView: UIView {

    @IBOutlet weak var gpaLabel: UILabel!
    @IBOutlet weak var termTitleLabel: UILabel!
    @IBOutlet weak var courseNumLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
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
        
        termTitleLabel.font = UIFont.init(name: "PingFangSC-SemiBold", size: 16.0)
        gpaLabel.font = UIFont.init(name: "PingFangSC-Light", size: 35.0)
        courseNumLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 13.0)
        courseNumLabel.textColor = UIColor.gray
        termTitleLabel.sizeToFit()
        gpaLabel.sizeToFit()
        courseNumLabel.sizeToFit()
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }

}
