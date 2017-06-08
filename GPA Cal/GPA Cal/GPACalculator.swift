//
//  GPACalculator.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/7.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

class GPACalculator: NSObject {

    class func calculateGPA(courseList : [CourseModel]) -> Float{
        var sum: Float = 0.0
        var sumCredit: Float = 0.0
        for course in courseList{
            sum += course.score! * (course.credit ?? 0)
            sumCredit += (course.credit ?? 0)
        }
        return (sum / sumCredit) / 20
    }
    
}
