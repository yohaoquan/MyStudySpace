//
//  NotesHelpers.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/21/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation

func getNotes(orgUnit: OrgUnit){
    var res = Contents(Modules: [])
    if !LoginHelper.sharedInstance.loginState!.isOnline {
        let data = UserDefaults.standard.data(forKey: String(orgUnit.Id)+"notes")
        if data == nil {
            let empty = try! JSONEncoder().encode(Contents(Modules: []))
            UserDefaults.standard.set(empty, forKey: String(orgUnit.Id)+"notes")
        }
        return
    }
    let url1 = generateURLForRoute(route: "/d2l/api/le/1.34/" + String(orgUnit.Id) + "/content/root", method: .GET)
    var url2: URL!
    let semaphore = DispatchSemaphore(value: 0)
    URLSession.shared.dataTask(with: url1!) { data, response, error in
        if let data = data {
            do {
                print("Got link!")
                let res = try JSONDecoder().decode(URLResponse.self, from: data)
                url2 = URL(string: res.url)
                print(String(describing: url2))
            } catch let error {
                presentAlert("Oops", "We can't seem to connect with our sever right now. Please restart the app and try again.")
                print(error)
                return
            }
        }
        semaphore.signal()
    }.resume()
    _ = semaphore.wait(wallTimeout: .distantFuture)
    if url2 == nil {
        print("getNotes(): url2 is nil. Returning. Check network.")
        return
    }
    var accessURL = URLComponents(url: url2, resolvingAgainstBaseURL: true)
    print(String(describing: accessURL?.url))
    URLSession.shared.dataTask(with: accessURL!.url!) { data, response, error in
        if let data = data {
            do {
                print("Got data!")
                res = try JSONDecoder().decode(Contents.self, from: data)
                let encoded = try? JSONEncoder().encode(res)
                UserDefaults.standard.set(encoded, forKey: String(orgUnit.Id)+"notes")
            } catch let error {
                presentAlert("Rats!", "We can't seem to connect with our sever right now. Please restart the app and try again.")
                print(error)
                return
            }
        }
        semaphore.signal()
    }.resume()
    _ = semaphore.wait(timeout: .distantFuture)
    return
    
}




// MARK: - Contents
struct Contents: Codable {
    var Modules: [Module]

    enum CodingKeys: String, CodingKey {
        case Modules
    }
}

// MARK: - Module
struct Module: Codable {
    var IsHidden: Bool
    var SortOrder: Int
    var StartDateTime, EndDateTime: String?
    var IsLocked: Bool
    var PacingStartDate, PacingEndDate: String?
    var DefaultPath: String
    var ModuleID: Int
    var Title: String
    var Modules: [Topic]?
    var Topics: [Topic]
    var LastModifiedDate: String
    var ModuleDescription: Description

    enum CodingKeys: String, CodingKey {
        case IsHidden
        case SortOrder
        case StartDateTime
        case EndDateTime
        case IsLocked
        case PacingStartDate
        case PacingEndDate
        case DefaultPath
        case ModuleID
        case Title
        case Modules
        case Topics
        case LastModifiedDate
        case ModuleDescription
    }
}

// MARK: - Description
struct Description: Codable {
    var Text, Html: String

    enum CodingKeys: String, CodingKey {
        case Text
        case Html
    }
}

// MARK: - Topic
struct Topic: Codable {
    var IsExempt, IsHidden: Bool
    var SortOrder: Int
    var StartDateTime, EndDateTime: String?
    var IsLocked, IsBroken: Bool
    var ActivityID: String
    var CompletionType, TopicID: Int
    var Identifier: String
    var TypeIdentifier: TypeIdentifier
    var Title: String
    var Bookmarked, Unread: Bool
    var Url: String
    var ToolID, ToolItemID: Int?
    var ActivityType: Int
    var GradeItemID: Int?
    var LastModifiedDate: String
    var TopicDescription: Description

    enum CodingKeys: String, CodingKey {
        case IsExempt
        case IsHidden
        case SortOrder
        case StartDateTime
        case EndDateTime
        case IsLocked
        case IsBroken
        case ActivityID
        case CompletionType
        case TopicID
        case Identifier
        case TypeIdentifier
        case Title
        case Bookmarked
        case Unread
        case Url
        case ToolID
        case ToolItemID
        case ActivityType
        case GradeItemID
        case LastModifiedDate
        case TopicDescription
    }
}

enum TypeIdentifier: String, Codable {
    case file = "File"
}

