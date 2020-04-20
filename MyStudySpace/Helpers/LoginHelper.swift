//
//  LoginHelper.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/6/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation
import Network

class LoginState: NSObject, NSCoding {
    
    var isOnline = false
    var isLoggedIn = false
    var userId = ""
    var userKey = ""
    var userInfo = WhoamiResponse(Identifier: "", FirstName: "", LastName: "", UniqueName: "", ProfileIdentifier: "")
    let isLoggedInKey = "isLoggedIn"
    let userIdKey = "userId"
    let userKeyKey = "userKey"
    let userInfoKey = "userInfoKey"
    
    
    init(userId: String, userKey: String) {
        self.isLoggedIn = true
        self.userId = userId
        self.userKey = userKey
    }
    override init(){
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(isLoggedIn, forKey: isLoggedInKey)
        coder.encode(userId, forKey: userIdKey)
        coder.encode(userKey, forKey: userKeyKey)
        coder.encode(try! JSONEncoder().encode(userInfo), forKey: userInfoKey)
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
        isLoggedIn = (coder.decodeBool(forKey: isLoggedInKey))
        userId = (coder.decodeObject(forKey: userIdKey) as! String)
        userKey = (coder.decodeObject(forKey: userKeyKey) as! String)
        let infodata = coder.decodeObject(forKey: userInfoKey)
        if infodata != nil {
            userInfo = try! JSONDecoder().decode(WhoamiResponse.self, from: infodata as! Data)
        }else{
            userInfo = WhoamiResponse(Identifier: "", FirstName: "", LastName: "", UniqueName: "", ProfileIdentifier: "")
        }
        
    }
    
}

class LoginHelper {
    static let sharedInstance = LoginHelper()
    let fileName = "MyStudySpace.loginState"
    private let rootKey = "rootKey"
    var loginState : LoginState?
    
    func startMonitorNetworkState(){
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                LoginHelper.sharedInstance.loginState!.isOnline = true
            } else {
                LoginHelper.sharedInstance.loginState!.isOnline = false
            }
            
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        return documentsDirectory.appendingPathComponent(fileName) as String
    }
    func loadLoginState(){
        print("loading loginState...")
        let filePath = self.dataFilePath()
        if (FileManager.default.fileExists(atPath: filePath)) {
            let data = NSMutableData(contentsOfFile: filePath)!
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
            LoginHelper.sharedInstance.loginState =
                unarchiver.decodeObject(forKey: rootKey) as? LoginState
            unarchiver.finishDecoding()
        }
    }
    func saveLoginState(){
        let filePath = self.dataFilePath()
        print("saving loginState")
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(LoginHelper.sharedInstance.loginState,
                        forKey: rootKey)
        archiver.finishEncoding()
        data.write(toFile: filePath, atomically: true)
    }
    
}
