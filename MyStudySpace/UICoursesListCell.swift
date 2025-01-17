//
//  CoursesListCell.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/7/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit
import BlockiesSwift

class UICoursesListCell: UITableViewCell {
    @IBOutlet weak var bgp: UIImageView!
    @IBOutlet weak var coursename: UILabel!
    var cName = ""
    var orgunit = OrgUnit(id: 0, type: nil, name: "", code: "")
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell() {
        coursename.text = cName
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
