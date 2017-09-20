//
//  GPACalculator.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/7.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

class GPACalculator: NSObject {
    
    private override init() {
        
    }
    
    public static let sharedCalculator = GPACalculator()

    func calculateGPA(courseList: [CourseModel]) -> Float {
        var sum: Float = 0.0
        var sumCredit: Float = 0.0
        for course in courseList{
            sum += (course.score ?? 0) * (course.credit ?? 0)
            sumCredit += (course.credit ?? 0)
        }
        return sumCredit == 0 ? 0 :  (sum / sumCredit) / 20
    }
    
}
