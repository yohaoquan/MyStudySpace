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
    let url1 = generateURLForRoute(route: "/d2l/api/le/1.34/" + String(orgUnit.Id) + "/content/toc", method: .GET)
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
    var ModuleId: Int
    var Title: String
    var Modules: [Module]?
    var Topics: [Topic]
    var LastModifiedDate: String
    var Description: Description2?

    enum CodingKeys: String, CodingKey {
        case IsHidden
        case SortOrder
        case StartDateTime
        case EndDateTime
        case IsLocked
        case PacingStartDate
        case PacingEndDate
        case DefaultPath
        case ModuleId
        case Title
        case Modules
        case Topics
        case LastModifiedDate
        case Description
    }
}

// MARK: - Description
struct Description2: Codable {
    var Text, Html: String?

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
    var ActivityId: String
    var CompletionType, TopicId: Int
    var Identifier: String
    var TypeIdentifier: TypeIdentifier
    var Title: String
    var Bookmarked, Unread: Bool
    var Url: String
    var ToolId, ToolItemId: Int?
    var ActivityType: Int
    var GradeItemId: Int?
    var LastModifiedDate: String
    var Description: Description2?

    enum CodingKeys: String, CodingKey {
        case IsExempt
        case IsHidden
        case SortOrder
        case StartDateTime
        case EndDateTime
        case IsLocked
        case IsBroken
        case ActivityId
        case CompletionType
        case TopicId
        case Identifier
        case TypeIdentifier
        case Title
        case Bookmarked
        case Unread
        case Url
        case ToolId
        case ToolItemId
        case ActivityType
        case GradeItemId
        case LastModifiedDate
        case Description
    }
}

enum TypeIdentifier: String, Codable {
    case file = "File"
}

