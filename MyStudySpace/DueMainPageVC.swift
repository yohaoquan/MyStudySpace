//
//  DueMainPageVC.swift
//  
//
//  Created by Xiaohu He on 2020-04-22.
//

import UIKit

class DueMainPageVC: UITableViewController {

    var orgUnit: OrgUnit!
    var someDueDate: [DuedateItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            let group = DispatchGroup()
            queue.async(group: group) {
                refreshQuizzes(orgUnit: self.orgUnit)
                refreshDrops(orgUnit: self.orgUnit)
                let data = UserDefaults.standard.data(forKey: self.orgUnit.Name + "drop")
                let res = try! JSONDecoder().decode([DuedateItem].self, from: data!)
                
                for item in res {
                    self.someDueDate.append(DuedateItem(name:item.name, type: item.type, time:item.time))
                }
                self.someDueDate.sort {$0.time < $1.time}
                let date = Date()
                print(date)
                var count = 0
                for i in self.someDueDate {
                    if (self.seperateString(time: i.time) < date) {
                        self.someDueDate.remove(at: count)
                    } else {
                        count += count
                    }
                }
                count = 0
                for i in self.someDueDate {
                    print(i.name)
                    print(self.seperateString(time: i.time))
                }
                if data == nil {
                    let empty = try! JSONEncoder().encode(Quizzes(Objects: [], Next: ""))
                    UserDefaults.standard.set(empty, forKey: self.orgUnit.Name + "drop")
                }
                return
            }
            group.notify(queue: queue) { // we want to be notified only when both background tasks are completed
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } //group.notify
        }//queue.async

        // Do any additional setup after loading the view.
    }
    func seperateString(time: String) -> Date {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let timeAfterRemovingMicroseconds = String(time.split(separator: ".")[0])+"Z"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from:timeAfterRemovingMicroseconds)
        
        
        return date!
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.someDueDate.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dueReuse", for: indexPath) as! DuedateCell

        cell.dateItem = self.someDueDate[indexPath.row]
        cell.updateCell()

        return cell
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
