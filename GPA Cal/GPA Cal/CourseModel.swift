//
//  CourseModel.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

class CourseModel: NSObject {
    
    enum courseType {
        case 通识
        case 通修
        case 公共
        case 选修
        case 平台
    }
    
    var chineseName:String;
    var englishName:String;
    var type:courseType;
    var credit:Int?;
    var score:Float;
    
    override init() {
        chineseName = "测试名"
        englishName = "Test Name"
        type = courseType.通修
        credit = nil
        score = 5.0
    }
    
}
