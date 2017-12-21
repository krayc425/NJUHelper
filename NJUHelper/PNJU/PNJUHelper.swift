//
//  PNJUHelper.swift
//  NJUHelper
//
//  Created by 宋 奎熹 on 2017/12/21.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let kLoginUrl = "http://p.nju.edu.cn/portal_io/login"
private let kLogoutUrl = "http://p.nju.edu.cn/portal_io/logout"
private let kCheckStatusUrl = "http://p.nju.edu.cn/portal_io/getinfo"

class PNJUHelper: NSObject {
    
    static let shared: PNJUHelper = PNJUHelper()
    
    private override init() {
        
    }
    
    func login(username: String, password: String, completion: @escaping (_ resultMsg: String) -> Void) {
        let postDict: Parameters = ["username": username,
                                    "password": password]
        
        Alamofire.request(kLoginUrl, method: .post, parameters: postDict).responseJSON { (response) in
            if let json = response.result.value {
                let result = JSON(json).dictionaryValue
                
                UserDefaults.standard.set(username, forKey: "pnju_username")
                UserDefaults.standard.set(password, forKey: "pnju_password")
                UserDefaults.standard.synchronize()
                
                completion(result["reply_msg"]?.stringValue ?? "")
            }
        }
    }
    
    func logout(completion: @escaping (_ resultMsg: String) -> Void) {
        Alamofire.request(kLogoutUrl, method: .post).responseJSON { (response) in
            if let json = response.result.value {
                let result = JSON(json).dictionaryValue
                
                completion(result["reply_msg"]?.stringValue ?? "")
            }
        }
    }
    
    func checkStatua(completion: @escaping (_ status: PNJULogStatus) -> Void) {
        var logStatus: PNJULogStatus = .logDisabled
        
        Alamofire.request(kCheckStatusUrl, method: .post).responseJSON { (response) in
            if let json = response.result.value {
                let result = JSON(json).dictionaryValue
                
                if let resultCode = result["reply_code"]?.intValue {
                    switch resultCode {
                    case 0:
                        logStatus = .logIn
                    case 2:
                        logStatus = .logOut
                    default:
                        logStatus = .logDisabled
                    }
                }
            }
            completion(logStatus)
        }
    }
    
}
