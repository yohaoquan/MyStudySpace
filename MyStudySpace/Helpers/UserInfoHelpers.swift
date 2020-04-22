//
//  UserInfoHelpers.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/19/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation
import UIKit


func refreshName(){
    if !LoginHelper.sharedInstance.loginState!.isOnline {
        return
    }
    let url1 = generateURLForRoute(route: "/d2l/api/lp/1.10/users/whoami", method: .GET)
    print(url1?.absoluteString)
    var url2: URL!
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
    if url2 == nil {
        print("refreshName(): url2 is nil. Returning. Check network.")
        return
    }
    URLSession.shared.dataTask(with: url2!) { data, response, error in
        if let data = data {
            do {
                print("Got link!")
                let res = try JSONDecoder().decode(WhoamiResponse.self, from: data)
                LoginHelper.sharedInstance.loginState?.userInfo = res
                LoginHelper.sharedInstance.saveLoginState()
            } catch let error {
                let alert = UIAlertController(title: "Oops", message: "We can't seem to connect with our sever right now. Please restart the app and try again. ", preferredStyle: .alert)
                print(error)
                UIApplication.visibleViewController!.present(alert, animated: true)
            }
        }
        semaphore.signal()
    }.resume()
    _ = semaphore.wait(timeout: .distantFuture)
    return
    
}


