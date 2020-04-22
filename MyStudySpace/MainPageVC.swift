//
//  MainPageVC.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/8/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//


import UIKit
import CardParts

class MainPageVC: CardsViewController {
    
    required init?(coder: NSCoder) {
        CardPartsMintTheme().apply()
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginState = LoginHelper.sharedInstance.loginState!
        var greetings = ""
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        if hour < 12 && hour > 6 {
            greetings = "Good Morning"
        } else if hour >= 12 && hour < 18 {
            greetings = "Good Afternoon"
        } else {
            greetings = "Good Evening"
        }
        self.navigationItem.title = greetings + ", " + loginState.userInfo.FirstName
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            
            let group = DispatchGroup()
            queue.async(group: group) {
                refreshName()
            }
            queue.async {
                refreshCourses()
            }
            group.notify(queue: queue) { // we want to be notified only when both background tasks are completed
                DispatchQueue.main.async {
                    self.navigationItem.title = greetings + ", " + loginState.userInfo.FirstName
                }
                
            } //group.notify
        }//queue.async
        
        // Comment out one of the loadCard functions to change cards and/or their order
        let cards: [CardPartsViewController] = [
            TitleCardController(title: " "),
            
            ThemedCardController(title: "Welcome to MyStudySpace!"),
            SpacerCard(title: " "),
            HomeLinksCardController()
            //            ThemedCardController(title: "Are"),
            //            ThemedCardController(title: "Themed"),
            //            ThemedCardController(title: "Cards!")
        ]
        loadCards(cards: cards)
    }
}
