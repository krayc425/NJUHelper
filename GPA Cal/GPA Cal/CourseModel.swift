//
//  CourseModel.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

enum courseType : String {
    case 通识 = "通识"
    case 通修 = "通修"
    case 公共 = "公共"
    case 选修 = "选修"
    case 平台 = "平台"
}

extension courseType { // 状态对应颜色
    var backgroundColor : UIColor {
        switch self {
        case .通识:
            return UIColor.red
        case .通修:
            return UIColor.blue
        case .平台:
            return UIColor.green
        case .选修:
            return UIColor.orange
        case .公共:
            return UIColor.purple
        }
    }
}

class CourseModel: NSObject {
    
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
