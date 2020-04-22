//
//  UICoursesList.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/6/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit


class NoteList: UITableViewController {
    var orgUnit: OrgUnit!
    var content = Contents(Modules: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.prompt = orgUnit.Name
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            let group = DispatchGroup()
            queue.async(group: group) {
                getNotes(orgUnit: self.orgUnit)
                self.content = try! JSONDecoder().decode(Contents.self, from: UserDefaults.standard.data(forKey: String(self.orgUnit.Id)+"notes")!)
                
                
            }
            group.notify(queue: queue) { // we want to be notified only when both background tasks are completed
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
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
        return self.content.Modules.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse", for: indexPath) as! UIModuleCell
        cell.module = self.content.Modules[indexPath.row]
        cell.modulenamelabel.text = cell.module.Title

        return cell
    }
    
    @IBAction func unwindToClsit(segue: UIStoryboardSegue) {
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
        let selected = self.tableView.cellForRow(at: self.tableView!.indexPathForSelectedRow!) as! UIModuleCell
        let dest = segue.destination as! UIDetailNoteListTable
        dest.topics = selected.module.Topics
        dest.navigationItem.title = selected.module.Title
        dest.navigationItem.prompt = self.navigationItem.prompt

    }
    

}
