//
//  DueCardController.swift
//  MyStudySpace
//
//  Created by Xiaohu He on 2020-04-20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation
import CardParts

class DueCardController: CardPartsViewController {
    
    let possibleGradientColors: [UIColor] = [
        UIColor(red: 181.0 / 255.0, green: 152.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0),
        UIColor(red: 30.0 / 255.0, green: 211.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0),
        UIColor(red: 63.0 / 255.0, green: 236.0 / 255.0, blue: 216.0 / 255.0, alpha: 1.0),
        UIColor(red: 27.0 / 255.0, green: 205.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0),
        UIColor(red: 10.0 / 255.0, green: 199.0 / 255.0, blue: 117.0 / 255.0, alpha: 1.0),
        UIColor(red: 17.0 / 255.0, green: 174.0 / 255.0, blue: 155.0 / 255.0, alpha: 1.0),
        UIColor(red: 128.0 / 255.0, green: 0.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0),
        UIColor(red: 75.0 / 255.0, green: 0.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0),
        UIColor(red: 148.0 / 255.0, green: 0.0 / 255.0, blue: 211.0 / 255.0, alpha: 1.0),
        UIColor(red: 138.0 / 255.0, green: 43.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0),
        UIColor(red: 255.0 / 255.0, green: 215.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0),
        UIColor(red: 218.0 / 255.0, green: 165.0 / 255.0, blue: 32.0 / 255.0, alpha: 1.0),
        UIColor(red: 255.0 / 255.0, green: 165.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0),
        UIColor(red: 139.0 / 255.0, green: 0.0 / 255.0, blue: 139.0 / 255.0, alpha: 1.0),
        UIColor(red: 189.0 / 255.0, green: 183.0 / 255.0, blue: 107.0 / 255.0, alpha: 1.0),
        UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0),
        UIColor(red: 153.0 / 255.0, green: 50.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0),
        UIColor(red: 186.0 / 255.0, green: 85.0 / 255.0, blue: 211.0 / 255.0, alpha: 1.0),
        UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0),
        UIColor(red: 240.0 / 255.0, green: 230.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0),
    ]
    
    var _title: String = ""
    
    convenience init(title: String) {
        self.init(nibName: nil, bundle: nil)
        self._title = title

        self.cardTapped {
            print("Card was tapped in .none state")
        }

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacer = CardPartSpacerView(height: 10.0)

        
        let titleCP = CardPartTextView(type: .header)
        titleCP.text = self._title
        titleCP.textAlignment = .center
        titleCP.textColor = .white
        
        
        let descriptionCP = CardPartTextView(type: .normal)
        descriptionCP.text = "Due Date and Schedules"
        descriptionCP.textColor = .white
        descriptionCP.textAlignment = .center
        descriptionCP.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        setupCardParts([spacer, titleCP, descriptionCP])
        
        view.addConstraint(NSLayoutConstraint(item: view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150))
    }
}

extension DueCardController: ShadowCardTrait {
    func shadowOffset() -> CGSize {
        return CGSize(width: 10.0, height: 10.0)
    }
    
    func shadowColor() -> CGColor {
        return UIColor.lightGray.cgColor
    }
    
    func shadowRadius() -> CGFloat {
        return 10.0
    }
    
    func shadowOpacity() -> Float {
        return 1.0
    }
}

extension DueCardController: RoundedCardTrait {
    func cornerRadius() -> CGFloat {
        return 10.0
    }
}

extension DueCardController: GradientCardTrait {
    func gradientColors() -> [UIColor] {
        
        let color1: UIColor = self.possibleGradientColors[Int(arc4random_uniform(UInt32(self.possibleGradientColors.count)))]
        var color2: UIColor = self.possibleGradientColors[Int(arc4random_uniform(UInt32(self.possibleGradientColors.count)))]
        
        while color1 == color2 {
            color2 = self.possibleGradientColors[Int(arc4random_uniform(UInt32(self.possibleGradientColors.count)))]
        }
        
        return [color1, color2]
    }
    
    func gradientAngle() -> Float {
        return 45.0
    }
}
