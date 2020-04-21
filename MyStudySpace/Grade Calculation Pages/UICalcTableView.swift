//
//  UICalcTableView.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/20/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit

class UICalcTableView: UITableViewController {
    var orgUnit: OrgUnit!
    var activityIndicatorView: UIActivityIndicatorView!
    var grades = gradearr()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        print("Got to Clac table view")
        
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            let group = DispatchGroup()
            queue.async(group: group) {
                getGrades(orgUnit: self.orgUnit)
                self.grades.gradesArr = try! JSONDecoder().decode(Grades.self, from: UserDefaults.standard.data(forKey: self.orgUnit.Name+String(self.orgUnit.Id))!)
                print("Grades are back. There are \(String(describing: self.grades.gradesArr.count)) entries. ")
                self.grades.gradesArr = self.grades.gradesArr.filter { $0.GradeObjectType == 1 }
                print("\(String(describing: self.grades.gradesArr.count)) after truncated. ")
                
                self.grades.gradesArr.insert(Grade(PointsNumerator: 0, PointsDenominator: 100, WeightedNumerator: 0, WeightedDenominator: 100, GradeObjectIdentifier: "0", GradeObjectName: "Overall", GradeObjectType: 1, GradeObjectTypeName: GradeObjectTypeName(rawValue: "Numeric")!, DisplayedGrade: "10%", Comments: Comments(Text: "", Html: ""), PrivateComments: Comments(Text: "", Html: ""), LastModified: "", LastModifiedBy: "", ReleasedDate: ""), at: 0)
                
                for _ in self.grades.gradesArr{
                    self.grades.enables.append(true)
                }
                for (index, element) in self.grades.gradesArr.enumerated() {
                    if element.WeightedNumerator != 0.0 {
                        self.grades.enables[index] = false
                        self.grades.gradesArr[0].WeightedNumerator += element.WeightedNumerator
                        self.grades.gradesArr[0].PointsNumerator += element.WeightedNumerator
                    }
                }
                
            }
            group.notify(queue: queue) { // we want to be notified only when both background tasks are completed
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.isHidden = true
                }
            } //group.notify
        }//queue.async
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.grades.gradesArr.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! UIGradeItemCell
        print("dequeueReusableCell Called")
        cell.gradearr = self.grades
        cell.index = indexPath.row
        cell.HostVC = self
        cell.updateCell()
        
        
        return cell
    }
    
    func calcOverAll() -> Double{
        var overall: Double = 0.0
        for (index, element) in self.grades.gradesArr.enumerated() {
            if index == 0 {
                continue
            }
            if element.WeightedNumerator != 0.0 {
                overall += element.WeightedNumerator
            }
        }
        print("calcOverAll returned \(String(overall))")
        return overall
    }
    
    func calcAndUpdate(index: Int, gradeItem: Grade){
        print("calcAndUpdate Called")
        let numOfEnabled = numberOfEnabled()
        if self.grades.enables[0] && numOfEnabled > 1 && index != 0{ // When sliding GradeItem with overall enabled.
            self.grades.gradesArr[index] = gradeItem
            let overall = calcOverAll()
            self.grades.gradesArr[0].WeightedNumerator = overall
            self.grades.gradesArr[0].PointsNumerator = overall
        } else  if !self.grades.enables[0] && numOfEnabled > 1 { //When sliding GradeItem with overall disabled and more than one gradeItem enabled
            let diff = self.grades.gradesArr[index].WeightedNumerator - gradeItem.WeightedNumerator
            let increment = diff / Double(numOfEnabled - 1)
            for (i, _) in self.grades.gradesArr.enumerated() {
                if index == i || !self.grades.enables[i] {
                    continue
                }
                self.grades.gradesArr[i].WeightedNumerator += increment
                self.grades.gradesArr[i].PointsNumerator = self.grades.gradesArr[i].WeightedNumerator / self.grades.gradesArr[i].WeightedDenominator
            
            }
        } else { //sliding Overall when more than one greadeItem enabled
            let diff = self.grades.gradesArr[index].WeightedNumerator - gradeItem.WeightedNumerator
            let increment = -(diff / Double(numOfEnabled - 1))
            for (i, _) in self.grades.gradesArr.enumerated() {
                if i == 0 || !self.grades.enables[i] {
                    continue
                }
                self.grades.gradesArr[i].WeightedNumerator += increment
                self.grades.gradesArr[i].PointsNumerator = self.grades.gradesArr[i].WeightedNumerator / self.grades.gradesArr[i].WeightedDenominator * Double(self.grades.gradesArr[i].PointsDenominator)
            
            }
        }

        self.grades.gradesArr[index] = gradeItem
        self.tableView.reloadData()
    }
    
    func numberOfEnabled() -> Int {
        var count = 0
        for item in self.grades.enables{
            if item{
                count += 1
                
            }
        }
        return count
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


class gradearr {
    var gradesArr = Grades()
    var enables = [Bool]()
}
