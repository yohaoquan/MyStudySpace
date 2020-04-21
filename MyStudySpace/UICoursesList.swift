//
//  UICoursesList.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/6/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit


class UICoursesList: UITableViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            let group = DispatchGroup()
            queue.async(group: group) {
                refreshCourses()
            }
            group.notify(queue: queue) { // we want to be notified only when both background tasks are completed
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                }
                
            } //group.notify
        }//queue.async
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EnrollmentsHelper.sharedInstance.enrollments.Items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! UICoursesListCell

        cell.cName = EnrollmentsHelper.sharedInstance.enrollments.Items[indexPath.row].OrgUnit.Name
        cell.orgunit = EnrollmentsHelper.sharedInstance.enrollments.Items[indexPath.row].OrgUnit
        cell.updateCell()
        cell.bgp.backgroundColor = [#colorLiteral(red: 0.7725490196, green: 0.8196078431, blue: 0.9215686275, alpha: 0.7040327905),#colorLiteral(red: 0.6730698529, green: 0.747124183, blue: 0.9294117647, alpha: 0.7036751761),#colorLiteral(red: 0.7058823529, green: 0.7764705882, blue: 0.9294117647, alpha: 0.6987786092),#colorLiteral(red: 0.7529411765, green: 0.8039215686, blue: 0.9294117647, alpha: 0.7041703345)][indexPath.row % 4]

        return cell
    }
    
    @IBAction func unwindToClsit(segue: UIStoryboardSegue) {
    }
    
    @IBAction func goToMainFromCourse(_ sender: Any) {
        performSegue(withIdentifier: "goToMainFromCourseSegue", sender: self)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let selected = self.tableView.cellForRow(at: self.tableView!.indexPathForSelectedRow!) as! UICoursesListCell
        let dest = segue.destination as! CourseMainPageVC
        dest.orgUnit = selected.orgunit
    }
    

}
