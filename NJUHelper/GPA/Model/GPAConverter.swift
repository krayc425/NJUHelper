//
//  GPAConverter.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/9/20.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import Alamofire

class GPAConverter: NSObject {

    private let termRegex = try! NSRegularExpression(pattern: "<tr align=\"center\" height=\"22\">\\s*?<td><a  href=\"(\\S*?)\"/>(\\S*?)</a> </td>\\s*?</tr>", options: NSRegularExpression.Options(rawValue:0))
    
    private let courseRegex = try! NSRegularExpression(pattern: "<td valign=\"middle\">(.*?)</td>\\s*?<td valign=\"middle\">(.*?)</td>\\s*?<td align=\"center\" valign=\"middle\">\\s*?(.*?)\\s*?</td>\\s*?<td align=\"center\" valign=\"middle\">(.*?)</td>\\s*?<td align=\"center\" valign=\"middle\">\\s*?<ul\\s*?style=\"color:black\"\\s*?>\\s*?(\\S*?)\\s*?</ul>\\s*?</td>", options: NSRegularExpression.Options(rawValue:0))
    
    public static let sharedConverter = GPAConverter()
    
    private override init() {
        
    }
    
    func convertCourses(from string: String, completionHandler: @escaping (_ termModels: [TermModel]?) -> Void) {
        var termModelArray = [TermModel]()
        
        let res = termRegex.matches(in: string,
                                    options: NSRegularExpression.MatchingOptions(rawValue:0),
                                    range: NSMakeRange(0, string.count))
        
        if res.count > 0 {
            for subStr in res {
                let termName = (string as NSString).substring(with: subStr.rangeAt(2))
                
                let termURL = "http://elite.nju.edu.cn/jiaowu/" + (string as NSString).substring(with: subStr.rangeAt(1))
                
                Alamofire.request(URL(string: termURL)!).responseString { (response) in
                    if response.result.isSuccess {
                        let courseString = String(data: response.data!, encoding: String.Encoding.utf8)!
                        
                        let courseRes = self.courseRegex.matches(in: courseString,
                                                                 options: NSRegularExpression.MatchingOptions(rawValue:0),
                                                                 range: NSMakeRange(0, courseString.count))
                        
                        if courseRes.count > 0 {
                            var courseModelArray = [CourseModel]()
                            for courseSubStr in courseRes {
                                let nsString = courseString as NSString
                                let courseModel = CourseModel(chineseName: nsString.substring(with: courseSubStr.rangeAt(1)),
                                                              englishName: nsString.substring(with: courseSubStr.rangeAt(2)),
                                                              typeString: nsString.substring(with: courseSubStr.rangeAt(3)).trimmingCharacters(in: .whitespacesAndNewlines),
                                                              credit: Float(nsString.substring(with: courseSubStr.rangeAt(4)).trimmingCharacters(in: .whitespacesAndNewlines)),
                                                              score: Float(nsString.substring(with: courseSubStr.rangeAt(5))))
                                courseModelArray.append(courseModel)
                            }
                            termModelArray.append(TermModel(name: termName, courseList: courseModelArray))
                            
                            if res.count == termModelArray.count {
                                completionHandler(termModelArray.sorted(by: { (model1, model2) -> Bool in
                                    model1.name.compare(model2.name) == ComparisonResult.orderedDescending
                                }))
                            }
                        }
                    } else {
                        print("Fail")
                        completionHandler(nil)
                    }
                }
            }
        } else {
            completionHandler(nil)
        }
    }
    
}
