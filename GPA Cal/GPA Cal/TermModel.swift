//
//  TermModel.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

class TermModel: NSObject {
    var name: String
    var courseList = [CourseModel]()
    
    init(name: String, courseList: [CourseModel]) {
        self.name = name
        self.courseList = courseList
    }
}
