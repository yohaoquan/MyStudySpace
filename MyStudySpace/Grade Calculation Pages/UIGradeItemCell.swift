//
//  UIGradeItemCell.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/21/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit

class UIGradeItemCell: UITableViewCell {
    @IBOutlet weak var gradePercent: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var maxMarkLabel: UILabel!
    @IBOutlet weak var gradePoint: UILabel!
    @IBOutlet weak var gradeItemName: UILabel!
    @IBOutlet weak var lockSwitch: UISwitch!
    var HostVC: UICalcTableView!
    var gradearr: gradearr!
    var gradeItem: Grade!
    var index: Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func SliderValueChanged(_ sender: Any) {
        if HostVC.numberOfEnabled() == 0 || (HostVC.numberOfEnabled() == 1 && gradearr.enables[index]) {
            updateCell()
            return
        }
        print(String(slider.value))
        gradeItem.PointsNumerator = Double(slider.value * Float(gradeItem.PointsDenominator))
        gradeItem.WeightedNumerator = Double(slider.value * Float(gradeItem.WeightedDenominator))
        HostVC.calcAndUpdate(index: index, gradeItem: gradeItem)
        updateCell()
    }
    
    
    
    
    
    @IBAction func GradeLockStatusChanged(_ sender: Any) {
        slider.isEnabled = lockSwitch.isOn
        self.gradearr.enables[index] = lockSwitch.isOn
    }
    

    func updateCell(){
        if self.gradeItem == nil {
            self.gradeItem = self.gradearr.gradesArr[index]
            self.slider.maximumValue = gradeItem.PointsNumerator / Double(gradeItem.PointsDenominator) > 1 ? 1.2 : 1
            self.slider.minimumValue = 0
            self.gradeItemName.text = gradeItem.GradeObjectName
            self.maxMarkLabel.text = String(format: "%.1f", gradeItem.WeightedDenominator)
            self.slider.isEnabled = self.gradearr.enables[index]
            self.lockSwitch.isOn = self.gradearr.enables[index]
        }else {
            self.gradeItem = self.gradearr.gradesArr[index]
            self.gradearr.gradesArr[index] = self.gradeItem
        }
        self.slider.value = Float(gradeItem.PointsNumerator / Double(gradeItem.PointsDenominator))
        self.gradePercent.text = String(format: "%.1f", gradeItem.PointsNumerator / Double(gradeItem.PointsDenominator) * 100)
        self.gradePoint.text = String(format: "%.1f", gradeItem.WeightedNumerator)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
