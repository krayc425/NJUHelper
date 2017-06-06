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

class GPATableViewController: UITableViewController {
    
    var termList = [TermModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let nib = UINib(nibName: CellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: CellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let username = "141210026", password = "Songkuixi+xw7"
        let requestURL = "http://localhost:8000/gpa/username=\(username)&password=\(password)"
        
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
                            credit = Float(subCourseDict["credit"] as! String) as! Float
                        }else{
                            credit = nil
                        }
                        let score : Float? = Float(subCourseDict["score"] as! String) as! Float
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
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return termList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let termModel : TermModel = termList[section]
        return termModel.courseList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> GPATableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! GPATableViewCell
        
        // Configure the cell...
        let termModel : TermModel = termList[indexPath.section]
        let course = termModel.courseList[indexPath.row]
        cell.chineseNameLabel.text = course.chineseName
        cell.englishNameLabel.text = course.englishName
        cell.scoreLabel.text = "\(course.score ?? 0.0)"
        if course.credit == nil{
            cell.creditLabel.text = "无学分"
        }else{
            cell.creditLabel.text = "\(course.credit!)" + "学分"
        }
        cell.typeLabel.text = "\(course.type)"
        
        cell.typeLabel.backgroundColor = course.type.backgroundColor
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let termModel : TermModel = termList[section]
        return termModel.name
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
