//
//  LoginHelper.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/6/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation


class LoginState: NSObject, NSCoding {

    
    var isLoggedIn = false
    var userId = ""
    var userKey = ""
    let AppId = "MCHLKRukvOZMCV1hchcsgg"
    let AppKey = "OextryfmALGx0PbknzAbdg"
    let callbackURL = "devcop.brightspace.com"
    let isLoggedInKey = "isLoggedIn"
    let userIdKey = "userId"
    let userKeyKey = "userKey"
    
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
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
        isLoggedIn = (coder.decodeBool(forKey: isLoggedInKey))
        userId = (coder.decodeObject(forKey: userIdKey) as! String)
        userKey = (coder.decodeObject(forKey: userKeyKey) as! String)
    }
    
}


class LoginHelper {
    static let sharedInstance = LoginHelper()
    let fileName = "MyStudySpace.loginState"
    private let rootKey = "rootKey"
    var loginState : LoginState?
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
