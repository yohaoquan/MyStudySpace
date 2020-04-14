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
        self.navigationItem.title = greetings + ", Aaron"
        
        // Comment out one of the loadCard functions to change cards and/or their order
        let cards: [CardPartsViewController] = [
            TitleCardController(title: " "),
            
            ThemedCardController(title: "Welcome to MyStudySpace!")
//            ThemedCardController(title: "Are"),
//            ThemedCardController(title: "Themed"),
//            ThemedCardController(title: "Cards!")
        ]
        loadCards(cards: cards)
    }
}
