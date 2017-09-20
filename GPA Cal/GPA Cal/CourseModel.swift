//
//  CourseModel.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

class CourseModel: NSObject {
    
    var chineseName: String
    var englishName: String
    var type: courseType
    var credit: Float?
    var score: Float?
    
    override init() {
        chineseName = "测试名"
        englishName = "Test Name"
        type = .通修
        credit = nil
        score = 5.0
    }
    
    init(chineseName: String, englishName: String, typeString: String, credit: Float?, score: Float?) {
        self.chineseName = chineseName
        self.englishName = englishName
        self.type = courseType(rawValue: typeString) ?? .通修
        self.credit = credit
        self.score = score
    }
    
    override var description: String {
        get {
            return "Score \(self.score ?? -1.0), Credit \(self.credit ?? -1.0)"
        }
    }
    
}
