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
    var userNameText: UITextField? {
        didSet {
            if let username = UserDefaults.standard.value(forKey: "username") as? String {
                userNameText?.text = username
            }
            self.userNameText?.delegate = self
        }
    }
    var passwordText: UITextField? {
        didSet {
            if let password = UserDefaults.standard.value(forKey: "password") as? String {
                passwordText?.text = password
            }
            self.passwordText?.delegate = self
        }
    }
    var validateCodeText: UITextField? {
        didSet {
            self.validateCodeText?.delegate = self
        }
    }
    var validateCodeButton: UIButton? {
        didSet {
            refreshValidateCode(self)
        }
    }
    var cookieArray = [ [HTTPCookiePropertyKey : Any ] ]()
    
    let cellIdentifier = "LoginTableViewCell"
    let cellCaptchaIdentifier = "LoginCaptchaTableViewCell"
    
    let validateCodeURL = URL(string: "http://elite.nju.edu.cn/jiaowu/ValidateCode.jsp")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Login"
        
        //TableView
        self.loginTableView = UITableView(frame: CGRect.init(x: 0, y: 64, width: self.view.bounds.size.width, height: 250), style: .grouped)
        self.loginTableView!.delegate = self
        self.loginTableView!.dataSource = self
        self.loginTableView?.backgroundColor = .clear
        self.loginTableView!.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.loginTableView?.register(UINib(nibName: cellCaptchaIdentifier, bundle: nil), forCellReuseIdentifier: cellCaptchaIdentifier)
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
        
        self.validateCodeButton?.addTarget(self, action: #selector(refreshValidateCode), for: .touchUpInside)
        
        //清空 cookie
        self.clearCookies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Login Action
    
    @objc func loginAction(sender: Any) {
        SVProgressHUD.show()
        
        let username = (userNameText?.text)!, password = (passwordText?.text)!, validateCode = (validateCodeText?.text)!
        let requestURL = "http://elite.nju.edu.cn/jiaowu/login.do"
        for cookieData in self.cookieArray {
            if let cookie = HTTPCookie.init(properties : cookieData) {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
        
        let postDict = ["userName": username,
                        "password": password,
                        "ValidateCode": validateCode]
        
        Alamofire.request(requestURL, method: .post, parameters: postDict ).responseString { (response) in
            
//            print(String(data: response.data!, encoding: String.Encoding.utf8) ?? "" )
            
            if let resultString = String(data: response.data!, encoding: String.Encoding.utf8) {
                if resultString.contains("验证码错误！") {
                    SVProgressHUD.showError(withStatus: "验证码错误")
                    SVProgressHUD.dismiss(withDelay: 2.0)
                } else if resultString.contains("用户名或密码错误！") {
                    SVProgressHUD.showError(withStatus: "用户名或密码错误")
                    SVProgressHUD.dismiss(withDelay: 2.0)
                }
            }
            
            if response.result.isSuccess {
                print("Success!")
                
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set(password, forKey: "password")
                UserDefaults.standard.synchronize()
                
                self.loadGradePoints()
            } else {
                print("Fail")
            }
        }

    }
    
    @objc func refreshValidateCode(_ sender: Any) {
        if let validateCodeURL = validateCodeURL {
            self.clearCookies()
            Alamofire.request(validateCodeURL).responseData(completionHandler: { (response) in
                let headerFields = response.response?.allHeaderFields as! [String: String]
                let url = response.request?.url
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url!)
                var cookieArray = [ [HTTPCookiePropertyKey : Any ] ]()
                for cookie in cookies {
                    cookieArray.append(cookie.properties!)
                }
                self.cookieArray = cookieArray
                
                self.validateCodeButton!.setBackgroundImage(UIImage(data: response.data!), for: .normal)
            })
        }
    }
    
    func loadGradePoints() {
        let commonURL = URL(string: "http://elite.nju.edu.cn/jiaowu/student/studentinfo/achievementinfo.do?method=searchTermList")
        Alamofire.request(commonURL!).responseString { (response) in
            if response.result.isSuccess {
                GPAConverter.sharedConverter.convertCourses(from: String(data: response.data!, encoding: String.Encoding.utf8)!, completionHandler: { (termModels) in
                    if let termList = termModels {
                        SVProgressHUD.dismiss()
                        
                        let loginVC = GPATableViewController()
                        loginVC.termList = termList
                        self.navigationController?.pushViewController(loginVC, animated: true)
                    }
                })
            } else {
                print("Fail")
            }
        }
    }
    
    private func clearCookies() {
        if let cookies = HTTPCookieStorage.shared.cookies(for: validateCodeURL!) {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LoginTableViewCell
            cell.loginLabel?.text = "用户名"
            let username = UserDefaults.standard.value(forKey: "username") as? String
            cell.loginText?.text = username ?? ""
            
            userNameText = cell.loginText
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LoginTableViewCell
            cell.loginLabel?.text = "密码"
            cell.loginText?.isSecureTextEntry = true
            let password = UserDefaults.standard.value(forKey: "password") as? String
            cell.loginText?.text = password ?? ""
            
            passwordText = cell.loginText
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellCaptchaIdentifier, for: indexPath) as! LoginCaptchaTableViewCell
            
            validateCodeText = cell.captchaText
            validateCodeButton = cell.captchaButton
            
            return cell
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "用户名和密码信息仅存储在本地，请放心使用"
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.userNameText {
            self.passwordText?.becomeFirstResponder()
        } else if textField == self.passwordText {
            self.validateCodeText?.becomeFirstResponder()
        } else {
            self.loginAction(sender: self.validateCodeText!)
        }
        return true
    }
    
}
