//
//  PNJUViewController.swift
//  NJUHelper
//
//  Created by 宋 奎熹 on 2017/12/20.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import SVProgressHUD

enum PNJULogStatus {
    case logIn
    case logOut
    case logDisabled
}

class PNJUViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifier = "LoginTableViewCell"
    
    convenience init(status: PNJULogStatus) {
        self.init(nibName: nil, bundle: nil)
        self.logStatus = status
    }
    
    var logStatus: PNJULogStatus = .logDisabled {
        didSet {
            self.refreshLoginButton()
        }
    }
    
    var loginTableView: UITableView?
    var loginButton: UIButton?
    var userNameText: UITextField? {
        didSet {
            if let username = UserDefaults.standard.value(forKey: "pnju_username") as? String {
                userNameText?.text = username
            }
            self.userNameText?.delegate = self
        }
    }
    var passwordText: UITextField? {
        didSet {
            if let password = UserDefaults.standard.value(forKey: "pnju_password") as? String {
                passwordText?.text = password
            }
            self.passwordText?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PNJU"

        //TableView
        loginTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 250), style: .grouped)
        loginTableView!.delegate = self
        loginTableView!.dataSource = self
        loginTableView?.backgroundColor = .clear
        loginTableView!.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        loginTableView?.isScrollEnabled = false
        self.view.addSubview(loginTableView!)
        
        //Button
        loginButton = UIButton(frame: CGRect(x: self.view.center.x - 40, y: (self.loginTableView?.frame.size.height)! + 20, width: 80, height: 40))
        loginButton?.setTitleColor(.white, for: UIControlState.normal)
        loginButton?.setTitle("不适用", for: .normal)
        loginButton?.isEnabled = false
        loginButton?.backgroundColor = .lightGray
        loginButton?.layer.cornerRadius = 5.0
        loginButton?.layer.masksToBounds = true
        loginButton?.addTarget(self, action: #selector(loginAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(loginButton!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.checkLogStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    func checkLogStatus() {
        logStatus = .logDisabled
        
        weak var weakSelf = self
        
        PNJUHelper.shared.checkStatua { (status) in
            weakSelf?.logStatus = status
            
            SVProgressHUD.dismiss()
        }
    }
    
    func refreshLoginButton() {
        switch (logStatus) {
        case .logDisabled:
            loginButton?.setTitle("不适用", for: .normal)
            loginButton?.isEnabled = false
            loginButton?.backgroundColor = .lightGray
        case .logIn:
            loginButton?.setTitle("登出", for: .normal)
            loginButton?.isEnabled = true
            loginButton?.backgroundColor = .pnju
        case .logOut:
            loginButton?.setTitle("登录", for: .normal)
            loginButton?.isEnabled =  true
            loginButton?.backgroundColor = .pnju
        }
    }
    
    // MARK: - Login Action
    
    @objc func loginAction() {
        SVProgressHUD.show()
        
        weak var weakSelf = self
        
        if logStatus == .logOut {
            
            let username = (userNameText?.text)!, password = (passwordText?.text)!
            
            PNJUHelper.shared.login(username: username, password: password, completion: { msg in
                SVProgressHUD.showInfo(withStatus: msg)
                SVProgressHUD.dismiss(withDelay: 1.0, completion: {
                    weakSelf?.checkLogStatus()
                })
            })
            
        } else if logStatus == .logIn {
            
            PNJUHelper.shared.logout(completion: { msg in
                SVProgressHUD.showInfo(withStatus: msg)
                SVProgressHUD.dismiss(withDelay: 1.0, completion: {
                    weakSelf?.checkLogStatus()
                })
            })
            
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LoginTableViewCell
            cell.loginLabel?.text = "用户名"
            let username = UserDefaults.standard.value(forKey: "pnju_username") as? String
            cell.loginText?.text = username ?? ""
            
            userNameText = cell.loginText
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LoginTableViewCell
            cell.loginLabel?.text = "密码"
            cell.loginText?.isSecureTextEntry = true
            let password = UserDefaults.standard.value(forKey: "pnju_password") as? String
            cell.loginText?.text = password ?? ""
            
            passwordText = cell.loginText
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "用户名和密码信息仅存储在本地，请放心使用"
    }

}

extension PNJUViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.userNameText {
            self.passwordText?.becomeFirstResponder()
        } else if textField == self.passwordText {
            self.loginAction()
        }
        return true
    }
    
}
