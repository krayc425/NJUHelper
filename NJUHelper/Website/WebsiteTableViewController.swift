//
//  WebsiteTableViewController.swift
//  NJUHelper
//
//  Created by 宋 奎熹 on 2017/12/21.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import SafariServices

class WebsiteTableViewController: UITableViewController {
    
    private let websiteArray = [("南京大学", "https://www.nju.edu.cn"),
                                ("教务网", "http://jw.nju.edu.cn"),
                                ("小百合", "http://bbs.nju.edu.cn"),
                                ("体育部", "http://tyb.nju.edu.cn"),
                                ("图书馆", "http://lib.nju.edu.cn"),
                                ("学生综合服务平台", "http://xsgl.nju.edu.cn"),
                                ("紫荆站", "http://zijingbt.njuftp.org"),
                                ("志愿服务平台", "http://volunteer.nju.edu.cn"),
                                ("校邮", "https://mail.nju.edu.cn"),
                                ("交换生管理系统", "http://elite.nju.edu.cn/exchangesystem")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "常用网站"
        
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websiteArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebsiteTableViewCell", for: indexPath) as! WebsiteTableViewCell

        cell.nameLabel.text = websiteArray[indexPath.row].0

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let safariVC = SFSafariViewController(url: URL(string: websiteArray[indexPath.row].1)!)
        present(safariVC, animated: true, completion: nil)
    }

}
