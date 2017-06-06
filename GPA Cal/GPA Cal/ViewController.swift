//
//  ViewController.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "GPA"
        self.navigationController?.navigationBar.isOpaque = true
        
        // Do any additional setup after loading the view, typically from a nib.
        let tableVC = GPATableViewController(style: UITableViewStyle.grouped)
        self.navigationController?.pushViewController(tableVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

