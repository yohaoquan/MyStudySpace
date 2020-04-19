//
//  HomeLinksCardController.swift
//  MyStudySpace
//
//  Created by Xiaohu He on 2020-04-17.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation
import CardParts
import RxSwift

class HomeLinksCardController: CardPartsViewController {
    
    lazy var linkToMLSBtnView: CardPartButtonView = {
        let button = CardPartButtonView()
        button.setTitle("                   My Learning Space                    ", for: .normal)
        button.setTitleColor(.yellowSea, for: .normal)
        button.backgroundColor = UIColor(red: 128.0 / 255.0, green: 0.0 / 255.0, blue: 128, alpha: 0.16)
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    lazy var linkToLorisBtnView: CardPartButtonView = {
        let button = CardPartButtonView()
        button.setTitle("                         Laurier Loris                         ", for: .normal)
        button.setTitleColor(.purple, for: .normal)
        button.backgroundColor = UIColor(red: 128.0 / 255.0, green: 0.0 / 255.0, blue: 128, alpha: 0.16)
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    lazy var linkToBohrBtnView: CardPartButtonView = {
        let button = CardPartButtonView()
        button.setTitle("                         Laurier Bohr                         ", for: .normal)
        button.setTitleColor(.eggBlue, for: .normal)
        button.backgroundColor = UIColor(red: 128.0 / 255.0, green: 0.0 / 255.0, blue: 128, alpha: 0.16)
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    lazy var linkToScheduleBtnView: CardPartButtonView = {
        let button = CardPartButtonView()
        button.setTitle("                        Schedule Me                        ", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.backgroundColor = UIColor(red: 128.0 / 255.0, green: 0.0 / 255.0, blue: 128, alpha: 0.16)
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    let cardPartSV1 = CardPartStackView()
    let cardPartSV2 = CardPartStackView()
    let cardPartSV3 = CardPartStackView()
    let cardPartSV4 = CardPartStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartSV1.axis = .horizontal
        cardPartSV1.distribution = .equalSpacing
        cardPartSV1.alignment = .leading
        cardPartSV2.axis = .horizontal
        cardPartSV2.distribution = .equalSpacing
        cardPartSV2.alignment = .leading
        cardPartSV3.axis = .horizontal
        cardPartSV3.distribution = .equalSpacing
        cardPartSV3.alignment = .leading
        cardPartSV4.axis = .horizontal
        cardPartSV4.distribution = .equalSpacing
        cardPartSV4.alignment = .leading
        
        
        let titlePart = CardPartTitleView(type: .titleOnly)
        titlePart.title = "Useful Links"
        titlePart.titleFont = UIFont.systemFont(ofSize: 30, weight: .bold)
        titlePart.titleColor = .darkGray
        
        linkToMLSBtnView.rx.tap.bind {
            self.openUrl(urlStr: "https://mylearningspace.wlu.ca")
        }.disposed(by: bag)
        
        linkToLorisBtnView.rx.tap.bind {
            self.openUrl(urlStr: "https://loris.wlu.ca")
        }.disposed(by: bag)
        
        linkToBohrBtnView.rx.tap.bind {
            self.openUrl(urlStr: "https://bohr.wlu.ca")
        }.disposed(by: bag)
        
        linkToScheduleBtnView.rx.tap.bind {
            self.openUrl(urlStr: "https://scheduleme.wlu.ca")
        }.disposed(by: bag)
        
        let image1 = CardPartImageView(image: UIImage(named: "flag"))
        image1.contentMode = UIView.ContentMode.scaleAspectFit
        cardPartSV1.addArrangedSubview(image1)
        cardPartSV1.addArrangedSubview(linkToMLSBtnView)
        
        let image2 = CardPartImageView(image: UIImage(named: "picker"))
        image2.contentMode = UIView.ContentMode.scaleAspectFit
        cardPartSV2.addArrangedSubview(image2)
        cardPartSV2.addArrangedSubview(linkToLorisBtnView)
        
        let image3 = CardPartImageView(image: UIImage(named: "clip"))
        image3.contentMode = UIView.ContentMode.scaleAspectFit
        cardPartSV3.addArrangedSubview(image3)
        cardPartSV3.addArrangedSubview(linkToBohrBtnView)
        
        let image4 = CardPartImageView(image: UIImage(named: "calendar"))
        image4.contentMode = UIView.ContentMode.scaleAspectFit
        cardPartSV4.addArrangedSubview(image4)
        cardPartSV4.addArrangedSubview(linkToScheduleBtnView)
        
        setupCardParts([titlePart, cardPartSV1, cardPartSV2, cardPartSV3, cardPartSV4])
    }
    
    func openUrl(urlStr:String!) {
        if let url = URL(string:urlStr), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension HomeLinksCardController: RoundedCardTrait {
    func cornerRadius() -> CGFloat {
        return 10.0
    }
}

extension HomeLinksCardController: ShadowCardTrait {
    func shadowOffset() -> CGSize {
        return CGSize(width: 1.0, height: 1.0)
    }
    
    func shadowColor() -> CGColor {
        return UIColor.label.cgColor
    }
    
    func shadowRadius() -> CGFloat {
        return 7.0
    }
    
    func shadowOpacity() -> Float {
        return 0.9
    }
}
