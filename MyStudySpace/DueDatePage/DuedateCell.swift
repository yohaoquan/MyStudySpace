//
//  DuedateCell.swift
//  MyStudySpace
//
//  Created by Xiaohu He on 2020-04-22.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit

class DuedateCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var dueTimeLabel: UILabel!
    var dateItem: DuedateItem!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateCell(){
        nameLabel.text = dateItem.name
        actionLabel.text = dateItem.type == 0 ?"Starts in" : "is due in"
        let diff = seperateString(time: dateItem.time).timeIntervalSince(Date())
        let minute:TimeInterval = 60.0
        let hour:TimeInterval = 60.0 * minute
        let day:TimeInterval = 24 * hour
        if Int(diff / day) > 0 {
            timeLeftLabel.text = String(Int(diff / day)) + " Days"
        } else if Int(diff / hour) > 0 {
            timeLeftLabel.text = String(Int(diff / hour)) + " Hours"
        } else if Int(diff / minute) > 0{
            timeLeftLabel.text = String(Int(diff / minute)) + " Minutes"
        } else {
            timeLeftLabel.text = "Less than a minute"
        }
        dueTimeLabel.text = toESTDate(seperateString(time: dateItem.time))
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func toESTDate(_ date: Date) -> String{
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd  HH:mm:ss"
        return format.string(from: date)
    }
    
    func seperateString(time: String) -> Date {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let timeAfterRemovingMicroseconds = String(time.split(separator: ".")[0])+"Z"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from:timeAfterRemovingMicroseconds)
        
        
        return date!
    }

}
