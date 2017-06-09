//
//  LoginViewController.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/8.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var loginTableView: UITableView?
    var loginButton: UIButton?
    var userNameText: UITextField?
    var passwordText: UITextField?
    
    let cellIdentifier = "LoginTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login"
        
        //TableView
        self.loginTableView = UITableView(frame: CGRect.init(x: 0, y: 64, width: self.view.bounds.size.width, height: 200), style: UITableViewStyle.plain)
        self.loginTableView!.delegate = self
        self.loginTableView!.dataSource = self
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        self.loginTableView!.register(nib, forCellReuseIdentifier: cellIdentifier)
        self.loginTableView?.isScrollEnabled = false
        self.view.addSubview(self.loginTableView!)
        
        //Button
        self.loginButton = UIButton.init(frame: CGRect(x: self.view.center.x - 40, y: (self.loginTableView?.frame.size.height)! + 84, width: 80, height: 40))
        self.loginButton?.setTitle("登录", for:  UIControlState.normal)
        self.loginButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.loginButton?.layer.backgroundColor = UIColor.init(red: 90.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1.0).cgColor
        self.loginButton?.layer.cornerRadius = 5.0
        self.loginButton?.layer.masksToBounds = true
        self.loginButton?.addTarget(self, action: #selector(loginAction(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(self.loginButton!)
        
        //Label
        let safetyLabel = UILabel.init(frame: CGRect(x: 18, y: (self.loginTableView?.frame.size.height)! + 35, width: self.view.bounds.size.width - 18, height: 20))
        safetyLabel.text = "用户名和密码信息仅存储在本地，请放心使用"
        safetyLabel.font = UIFont.init(name: "PingFangSC-Light", size: 11.0)
        safetyLabel.textColor = UIColor.lightGray
        self.view.addSubview(safetyLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Login Action
    
    func loginAction(sender: UIButton) {
        SVProgressHUD.show()
        
        let username = (userNameText?.text)!, password = (passwordText?.text)!
        let requestURL = "http://120.25.196.24:8001/gpa/username=\(username)&password=\(password)"
        
        Alamofire.request(requestURL).responseJSON { response in
            debugPrint(response)
            if let json = response.result.value {
                SVProgressHUD.dismiss()
                
                let array = json as! Array<AnyObject>
                
                if array.count == 0{
                    let alertC = UIAlertController.init(title: "登录失败", message:nil, preferredStyle: UIAlertControllerStyle.alert)
                    let OKAction = UIAlertAction.init(title: "好的", style: UIAlertActionStyle.default, handler:nil)
                    alertC.addAction(OKAction)
                    self.present(alertC, animated: true, completion:nil)
                    
                    return
                }else{
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.set(password, forKey: "password")
                    UserDefaults.standard.synchronize()
                }
                
                var resultList = [TermModel]()
                for dict in array{
                    let termName = dict["term"] as! String
                    let courseArr = dict["course_list"] as! Array<AnyObject>
                    var courseList = [CourseModel]()
                    for subCourseDict in courseArr{
                        let chineseName = subCourseDict["chinese_name"] as? String ?? ""
                        let englishName = subCourseDict["english_name"] as? String ?? ""
                        let credit : Float?
                        let type  = subCourseDict["type"] as? String ?? "通修"
                        if subCourseDict["credit"] as! String != ""{
                            credit = Float(subCourseDict["credit"] as! String)
                        }else{
                            credit = nil
                        }
                        let score : Float? = Float(subCourseDict["score"] as! String)
                        let courseModel = CourseModel()
                        courseModel.chineseName = chineseName
                        courseModel.englishName = englishName
                        courseModel.score = score
                        courseModel.credit = credit
                        courseModel.type = courseType(rawValue: type)!
                        courseList.append(courseModel)
                    }
                    let termModel = TermModel(name: termName, courseList: courseList)
                    resultList.append(termModel)
                }
                
                let loginVC = GPATableViewController()
                loginVC.termList = resultList
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }

    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LoginTableViewCell
        
        if indexPath.row == 0{
            cell.loginLabel?.text = "用户名"
            let username = UserDefaults.standard.value(forKey: "username") as? String
            cell.loginText?.text = username ?? ""
            
            userNameText = cell.loginText
        }else{
            cell.loginLabel?.text = "密码"
            cell.loginText?.isSecureTextEntry = true
            let password = UserDefaults.standard.value(forKey: "password") as? String
            cell.loginText?.text = password ?? ""
            
            passwordText = cell.loginText
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}
