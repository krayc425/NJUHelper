//
//  GPATableViewController.swift
//  GPA Cal
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import Alamofire

fileprivate let CellIdentifier = "GPATableViewCell"

class GPATableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TypeSelectionDelegate, GPATableViewCellDelegate {

    var termList = [TermModel]()
    var tableView: UITableView?
    var typeSelectionView: GPATypeSelectionView?
    var headerView: GPATableHeaderView?
    
    var ignoreCourseSet = Set<IndexPath>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "GPA"
        
        self.view.backgroundColor = .white
        
        let selectionViewHeight: CGFloat = 30.0
 
        tableView = UITableView(frame: CGRect(x: 0, y: 20 + selectionViewHeight + 60, width: kScreenWidth, height: kScreenHeight - selectionViewHeight - 80 - 64), style: .grouped)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.register(UINib(nibName: CellIdentifier, bundle: nil), forCellReuseIdentifier: CellIdentifier)
        self.view.addSubview(self.tableView!)
        
        typeSelectionView = GPATypeSelectionView(frame: CGRect(x: 0, y: 10, width: kScreenWidth, height: selectionViewHeight))
        typeSelectionView?.delegate = self
        self.view.addSubview(self.typeSelectionView!)
        
        headerView = GPATableHeaderView(frame: CGRect(x: 0, y: 40, width: kScreenWidth, height: 60))
        headerView?.termTitleLabel.text = "全部"
        self.view.addSubview(self.headerView!)
        
        reloadAllGPA()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func reloadMyTableView() {
        self.tableView?.reloadData()
        reloadAllGPA()
    }
    
    private func reloadAllGPA() {
        var allCourseList = [CourseModel]()
        for term in termList {
            allCourseList.append(contentsOf: term.courseList.filter {
                let coursePath = IndexPath(row: term.courseList.index(of: $0)!, section: termList.index(of: term)!)
                return !ignoreCourseSet.contains(coursePath)
            })
        }
        let gpaResult = GPACalculator.sharedCalculator.calculateGPA(courseList: allCourseList)
        headerView?.gpaLabel.text = String(format: "%.3f", gpaResult.0)
        headerView?.courseNumLabel.text = String(format: "共 %d 门课程，%d 个学分", allCourseList.count, gpaResult.1)
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
        
        if cell == nil {
            let nibList = Bundle.main.loadNibNamed(CellIdentifier, owner: nil, options: nil)
            cell = nibList?[0] as? GPATableViewCell
        }
        
        cell?.delegate = self
        
        let termModel: TermModel = termList[indexPath.section]
        let course = termModel.courseList[indexPath.row]
        cell?.chineseNameLabel.text = course.chineseName
        cell?.englishNameLabel.text = course.englishName
        cell?.scoreLabel.text = "\(course.score ?? 0.0)"
        if course.credit == nil {
            cell?.creditLabel.text = "无学分"
        } else {
            cell?.creditLabel.text = "\(course.credit!)" + "学分"
        }
        cell?.typeLabel.text = "\(course.type)"
        
        if ignoreCourseSet.contains(indexPath) {
            cell?.setSwitchValue(isSelected: false, animated: false)
            cell?.backgroundColor = UIColor.lightGray
            cell?.typeLabel.backgroundColor = UIColor.lightGray
        } else {
            cell?.setSwitchValue(isSelected: true, animated: false)
            cell?.backgroundColor = UIColor.white
            cell?.typeLabel.backgroundColor = course.type.backgroundColor
        }
    
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let path = IndexPath(row: indexPath.row, section: indexPath.section)
        if ignoreCourseSet.contains(path) {
            ignoreCourseSet.remove(path)
        } else {
            ignoreCourseSet.insert(path)
        }
        reloadMyTableView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = GPATableHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        let termModel: TermModel = termList[section]
        headerView.termTitleLabel.text = termModel.name
        
        let gpaResult = GPACalculator.sharedCalculator.calculateGPA(courseList: termModel.courseList.filter {
            let coursePath = IndexPath(row: termModel.courseList.index(of: $0)!, section: section)
            return !ignoreCourseSet.contains(coursePath)
        })
        headerView.gpaLabel.text = String(format: "%.3f", gpaResult.0)
        headerView.courseNumLabel.text = String(format: "共 %d 门课程，%d 个学分", termModel.courseList.count, gpaResult.1)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    // MARK: - Type Selection Delegate
    
    func didSelectType(courseType: courseType, isAdding: Bool) {
        if isAdding {
            self.ignoreCourseOfType(courseType: courseType)
        } else {
            self.notIgnoreCourseOfType(courseType: courseType)
        }
        reloadMyTableView()
    }
    
    func ignoreCourseOfType(courseType: courseType) {
        for term in self.termList {
            for course in term.courseList where course.type == courseType {
                let path = IndexPath.init(row: term.courseList.index(of: course)!, section: self.termList.index(of: term)!)
                if !ignoreCourseSet.contains(path) {
                    ignoreCourseSet.insert(path)
                }
            }
        }
    }
    
    func notIgnoreCourseOfType(courseType: courseType) {
        for term in self.termList {
            for course in term.courseList where course.type == courseType {
                let path = IndexPath.init(row: term.courseList.index(of: course)!, section: self.termList.index(of: term)!)
                if ignoreCourseSet.contains(path) {
                    ignoreCourseSet.remove(path)
                }
            }
        }
    }
    
    // MARK: - GPATableCell Delegate
    
    func didDeselectGPACell(cell: GPATableViewCell?) {
        let cellPath = self.tableView?.indexPath(for: (cell)!)
        let newPath = IndexPath.init(row: (cellPath?.row)!, section: (cellPath?.section)!)
        if !ignoreCourseSet.contains(newPath) {
            ignoreCourseSet.insert(newPath)
        }
        reloadMyTableView()
    }
    
    func didSelectGPACell(cell: GPATableViewCell?) {
        let cellPath = self.tableView?.indexPath(for: (cell)!)
        let newPath = IndexPath.init(row: (cellPath?.row)!, section: (cellPath?.section)!)
        if ignoreCourseSet.contains(newPath) {
            ignoreCourseSet.remove(newPath)
        }
        reloadMyTableView()
    }
    
}
