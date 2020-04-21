//
//  UIHelpers.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/20/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation
import UIKit





extension UIApplication {
    static var visibleViewController: UIViewController? {
        var currentVc = UIApplication.shared.keyWindow?.rootViewController
        while let presentedVc = currentVc?.presentedViewController {
            if let navVc = (presentedVc as? UINavigationController)?.viewControllers.last {
                currentVc = navVc
            } else if let tabVc = (presentedVc as? UITabBarController)?.selectedViewController {
                currentVc = tabVc
            } else {
                currentVc = presentedVc
            }
        }
        return currentVc
    }
}


func presentAlert(_ title:String, _ message:String) {
    let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
    DispatchQueue.main.async {
        UIApplication.visibleViewController!.present(alert, animated: true)
    }
}
