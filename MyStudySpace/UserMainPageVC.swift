//
//  UserMainPageVC.swift
//  MyStudySpace
//
//  Created by Xiaohu He on 2020-04-21.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import UIKit
import CardParts

class UserMainPageVC: CardsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let cards: [CardPartsViewController] = [
            UserInCardController()
        ]
        
        loadCards(cards: cards)
        // Do any additional setup after loading the view.
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
