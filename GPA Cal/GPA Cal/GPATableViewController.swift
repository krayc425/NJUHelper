//
//  GPATableViewController.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import Alamofire

let CellIdentifier = "GPATableViewCell"

class GPATableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TypeSelectionDelegate, GPATableViewCellDelegate {

    var termList = [TermModel]()
    var tableView: UITableView?
    var typeSelectionView: GPATypeSelectionView = GPATypeSelectionView.instanceFromNib()
    
    var ignoreCourseSet = Set<IndexPath>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusbarHeight: CGFloat = 40.0
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
 
        self.tableView = UITableView(frame: CGRect(x: 0, y: statusbarHeight, width: displayWidth, height: displayHeight - statusbarHeight), style: UITableViewStyle.grouped)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        let nib = UINib(nibName: CellIdentifier, bundle: nil)
        self.tableView!.register(nib, forCellReuseIdentifier: CellIdentifier)
        self.view.addSubview(self.tableView!)
        
        self.typeSelectionView.frame = CGRect(x: 0, y: 64, width: displayWidth, height: statusbarHeight)
        self.typeSelectionView.delegate = self
        self.view.addSubview(self.typeSelectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let username = "141210026", password = "Songkuixi+xw7"
        let requestURL = "http://120.25.196.24:8001/gpa/username=\(username)&password=\(password)"
        
        Alamofire.request(requestURL).responseJSON { response in
            debugPrint(response)
            if let json = response.result.value {
                let array = json as! Array<AnyObject>
                var resultList = [TermModel]()
                for dict in array{
                    let termName = dict["term"] as! String
                    let courseArr = dict["course_list"] as! Array<AnyObject>
                    var courseList = [CourseModel]()
                    for subCourseDict in courseArr{
                        let chineseName = subCourseDict["chinese_name"] as? String ?? ""
                        let englishName = subCourseDict["english_name"] as? String ?? ""
                        let credit : Float?
                        let type  = subCourseDict["type"] as? String ?? "通修"
                        if subCourseDict["credit"] as! String != ""{
                            credit = Float(subCourseDict["credit"] as! String)
                        }else{
                            credit = nil
                        }
                        let score : Float? = Float(subCourseDict["score"] as! String)
                        let courseModel = CourseModel()
                        courseModel.chineseName = chineseName
                        courseModel.englishName = englishName
                        courseModel.score = score
                        courseModel.credit = credit
                        courseModel.type = courseType(rawValue: type)!
                        courseList.append(courseModel)
                    }
                    let termModel = TermModel(name: termName, courseList: courseList)
                    resultList.append(termModel)
                }
                self.termList = resultList
                self.tableView!.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return termList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let termModel : TermModel = termList[section]
        return termModel.courseList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tableView?.cellForRow(at: indexPath) as? GPATableViewCell
        
        if(cell == nil){
            let nibList = Bundle.main.loadNibNamed(CellIdentifier, owner: nil, options: nil)
            cell = nibList?[0] as? GPATableViewCell
        }
        
        cell?.delegate = self
        
        let termModel: TermModel = termList[indexPath.section]
        let course = termModel.courseList[indexPath.row]
        cell?.chineseNameLabel.text = course.chineseName
        cell?.englishNameLabel.text = course.englishName
        cell?.scoreLabel.text = "\(course.score ?? 0.0)"
        if course.credit == nil{
            cell?.creditLabel.text = "无学分"
        }else{
            cell?.creditLabel.text = "\(course.credit!)" + "学分"
        }
        cell?.typeLabel.text = "\(course.type)"
        
        if ignoreCourseSet.contains(indexPath){
            cell?.setSwitchValue(isSelected: false, animated: false)
            cell?.backgroundColor = UIColor.lightGray
            cell?.typeLabel.backgroundColor = UIColor.lightGray
        }else{
            cell?.setSwitchValue(isSelected: true, animated: false)
            cell?.backgroundColor = UIColor.white
            cell?.typeLabel.backgroundColor = course.type.backgroundColor
        }
    
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let path = IndexPath.init(row: indexPath.row, section: indexPath.section)
        if ignoreCourseSet.contains(path){
            ignoreCourseSet.remove(path)
        }else{
            ignoreCourseSet.insert(path)
        }
        self.tableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = GPATableHeaderView.instanceFromNib()
        let termModel : TermModel = termList[section]
        headerView.termTitleLabel.text = termModel.name
        headerView.gpaLabel.text = String(format: "%.3f", GPACalculator.calculateGPA(courseList: termModel.courseList.filter{
            
            let coursePath = IndexPath.init(row: termModel.courseList.index(of: $0)!, section: section)
            return !ignoreCourseSet.contains(coursePath)
            
        }))
        headerView.courseNumLabel.text = String(format: "共 %d 门课程", termModel.courseList.count)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        return UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    // MARK: - TypeSelectionDelegate
    
    func didSelectType(courseType: courseType, isAdding: Bool){
        if isAdding{
            self.ignoreCourseOfType(courseType: courseType)
        }else{
            self.notIgnoreCourseOfType(courseType: courseType)
        }
        self.tableView?.reloadData()
    }
    
    func ignoreCourseOfType(courseType: courseType) {
        for term in self.termList{
            for course in term.courseList{
                if course.type == courseType{
                    let path = IndexPath.init(row: term.courseList.index(of: course)!, section: self.termList.index(of: term)!)
                    if !ignoreCourseSet.contains(path){
                        ignoreCourseSet.insert(path)
                    }
                }
            }
        }
    }
    
    func notIgnoreCourseOfType(courseType: courseType) {
        for term in self.termList{
            for course in term.courseList{
                if course.type == courseType{
                    let path = IndexPath.init(row: term.courseList.index(of: course)!, section: self.termList.index(of: term)!)
                    if ignoreCourseSet.contains(path){
                        ignoreCourseSet.remove(path)
                    }
                }
            }
        }
    }
    
    // MARK: - GPATableCellDelegate
    
    func didDeselectGPACell(cell: GPATableViewCell?) {
        let cellPath = self.tableView?.indexPath(for: (cell)!)
        let newPath = IndexPath.init(row: (cellPath?.row)!, section: (cellPath?.section)!)
        if !ignoreCourseSet.contains(newPath){
            ignoreCourseSet.insert(newPath)
        }
        self.tableView?.reloadData()
    }
    
    func didSelectGPACell(cell: GPATableViewCell?) {
        let cellPath = self.tableView?.indexPath(for: (cell)!)
        let newPath = IndexPath.init(row: (cellPath?.row)!, section: (cellPath?.section)!)
        if ignoreCourseSet.contains(newPath){
            ignoreCourseSet.remove(newPath)
        }
        self.tableView?.reloadData()
    }
    
}
