//
//  UIModuleCell.swift
//  MyStudySpace
//
//  Created by fyc on 2020-04-21.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit

class UIModuleCell: UITableViewCell {
    @IBOutlet weak var modulenamelabel: UILabel!
    var module: Module!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
