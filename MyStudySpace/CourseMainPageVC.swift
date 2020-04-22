//
//  CourseMainPageVC.swift
//  MyStudySpace
//
//  Created by Xiaohu He on 2020-04-17.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit
import CardParts

class CourseMainPageVC: CardsViewController {
    var orgUnit: OrgUnit?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = orgUnit?.Name
        
        let cards: [CardPartsViewController] = [
            NoteCardController(),
            MarkCardController(),
            DueCardController()
        ]
        loadCards(cards: cards)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGradeCalc" {
            if let dest = segue.destination as? UICalcTableView {
                dest.orgUnit = self.orgUnit
            }
        } else if segue.identifier == "goToDueFromCMPSegue" {
            if let dest = segue.destination as? DueMainPageVC {
                dest.orgUnit = self.orgUnit
            }
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
