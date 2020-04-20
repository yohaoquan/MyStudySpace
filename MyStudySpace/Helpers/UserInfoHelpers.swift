//
//  UserInfoHelpers.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/19/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation
import UIKit


func refreshNameAndCourses(){
    if !LoginHelper.sharedInstance.loginState!.isOnline {
        // TODO: Finish offline mode
        return
    }
    let url1 = generateURLForRoute(route: "/d2l/api/lp/1.10/users/whoami", method: .GET)
    var url2: URL!
    print("Got URL:")
    print(url1?.absoluteString)
    let semaphore = DispatchSemaphore(value: 0)
    URLSession.shared.dataTask(with: url1!) { data, response, error in
        if let data = data {
        do {
            print("Got link!")
            let res = try JSONDecoder().decode(URLResponse.self, from: data)
            url2 = URL(string: res.url)

        } catch let error {
            let alert = UIAlertController(title: "Oops", message: "We can't seem to connect with our sever right now. Please restart the app and try again.", preferredStyle: .alert)
            print(error)
            UIApplication.visibleViewController!.present(alert, animated: true)
            }
        }
        semaphore.signal()
    }.resume()
    _ = semaphore.wait(wallTimeout: .distantFuture)
    URLSession.shared.dataTask(with: url2!) { data, response, error in
        if let data = data {
        do {
            print("Got link!")
            let res = try JSONDecoder().decode(WhoamiResponse.self, from: data)
            LoginHelper.sharedInstance.loginState?.userInfo = res
            LoginHelper.sharedInstance.saveLoginState()
        } catch let error {
            let alert = UIAlertController(title: "Oops", message: "We can't seem to connect with our sever right now. Please restart the app and try again.", preferredStyle: .alert)
            print(error)
            UIApplication.visibleViewController!.present(alert, animated: true)
            }
        }
        semaphore.signal()
    }.resume()
    _ = semaphore.wait(timeout: .distantFuture)
    return
    
}

enum HTTPRequestType {
    case GET
    case POST
}

func generateURLForRoute(route: String, method:HTTPRequestType) -> URL? {
    if LoginHelper.sharedInstance.loginState!.isLoggedIn {
        var url = URLComponents(string: "https://aaronyoo.myfirewall.org/getPageUrl.php?&method=get&route=/d2l/api/lp/1.10/users/whoami")!

        url.queryItems = [
        URLQueryItem(name: "userId", value: LoginHelper.sharedInstance.loginState?.userId),
        URLQueryItem(name: "userKey", value: LoginHelper.sharedInstance.loginState?.userKey),
        URLQueryItem(name: "method", value: method == HTTPRequestType.GET ? "get" : "post"),
        URLQueryItem(name: "route", value: route)
        ]
        return url.url
    }
    return nil
}

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
