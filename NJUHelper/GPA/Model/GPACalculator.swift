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

    func calculateGPA(courseList: [CourseModel]) -> (Float, Int) {
        let sumCredit: Float = courseList.reduce(0.0, { $0 + ($1.credit ?? 0.0) }) // $0 指累加器（accumulator），$1 指遍历数组得到的一个元素
        let sum: Float = courseList.reduce(0.0, { $0 + ($1.score ?? 0.0) * ($1.credit ?? 0.0) })
        return (sumCredit == 0.0 ? 0.0 : (sum / sumCredit) / 20.0, Int(sumCredit))
    }
    
}
