//
//  NJUNavigationViewController.swift
//  NJUHelper
//
//  Created by 宋 奎熹 on 2017/12/21.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

class NJUNavigationViewController: UINavigationController, UIGestureRecognizerDelegate {
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count >= 1 {
            let button = UIButton(type: .custom)
            button.bounds = CGRect(x: 0, y: 0, width: 100, height: 21)
            button.setImage(#imageLiteral(resourceName: "nav_back"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "nav_back"), for: .highlighted)
            button.tintColor = .black
            button.contentHorizontalAlignment = .left
            button.contentEdgeInsets = UIEdgeInsets.zero
            button.addTarget(self, action: #selector(back), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func back() {
        self.popViewController(animated: true)
    }
    
}
