//
//  CourseHelper.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import Alamofire

class CourseHelper: NSObject {
    class func request(username : String, password : String) -> () {
        let requestURL = "http://localhost:8000/gpa/username=\(username)&password=\(password)"

        Alamofire.request(requestURL).responseJSON { response in
            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
            }
        }
    }
}
