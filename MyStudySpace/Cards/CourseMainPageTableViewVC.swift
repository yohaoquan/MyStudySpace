//
//  CourseMainPageTableViewVC.swift
//  MyStudySpace
//
//  Created by Xiaohu He on 2020-04-18.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation
import CardParts
import RxCocoa
import RxSwift

class CourseMainPageTableViewVC: CardPartsViewController {
   
   let cardPartTextView = CardPartTextView(type: .normal)
   let cardPartTableView = CardPartTableView()
   let viewModel = CardsTableViewModel()
   
   override func viewDidLoad() {
       super.viewDidLoad()
       
       cardPartTextView.text = "This is a CardPartTableView"
       
       viewModel.listData.asObservable().bind(to: cardPartTableView.tableView.rx.items) { tableView, index, data in
           
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: IndexPath(item: index, section: 0)) as? CardPartTableViewCell else { return UITableViewCell() }
           
           cell.leftTitleLabel.text = data
           
           return cell
       }.disposed(by: bag)
       
       setupCardParts([cardPartTextView, cardPartTableView])
   }
}

class CardsTableViewModel {

   let listData: BehaviorRelay<[String]> = BehaviorRelay(value: [])
   
   init() {
       
       var tempData: [String] = []
       
       for i in 0...5 {
           
           tempData.append("This is cell #\(i)")
       }
       
       listData.accept(tempData)
   }
}
