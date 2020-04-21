//
//  EnrollmentsStruct.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/20/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation
import UIKit

class EnrollmentsHelper {
    static let sharedInstance = EnrollmentsHelper()
    var enrollments = Enrollments(PagingInfo: PagingInfo(Bookmark: "0", HasMoreItems: false), Items: [])
}



func refreshCourses(){
    let res: Enrollments
    if !LoginHelper.sharedInstance.loginState!.isOnline {
        let data = UserDefaults.standard.data(forKey: "enrollments")
        do{
            res = try JSONDecoder().decode(Enrollments.self, from: data!)} catch {
                res = Enrollments(PagingInfo: PagingInfo(Bookmark: "", HasMoreItems: false), Items: [])
        }
        
        EnrollmentsHelper.sharedInstance.enrollments = res
        
        //TODO: Check if user have anything available offline. If they do, keep the course. If they don't, delete the course.
        return
    }
    let url1 = generateURLForRoute(route: "/d2l/api/lp/1.0/enrollments/myenrollments/", method: .GET)
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
        print("refreshCourses(): url2 is nil. Returning. Check network.")
        return
    }
    var accessURL = URLComponents(url: url2, resolvingAgainstBaseURL: true)
    accessURL?.queryItems?.append(URLQueryItem(name: "canAccess", value: "true"))
    accessURL?.queryItems?.append(URLQueryItem(name: "isActive", value: "true"))
    accessURL?.queryItems?.append(URLQueryItem(name: "orgUnitTypeId", value: "3"))
    print(String(describing: accessURL?.url))
    URLSession.shared.dataTask(with: accessURL!.url!) { data, response, error in
        if let data = data {
            do {
                print("Got data!")
                let res = try JSONDecoder().decode(Enrollments.self, from: data)
                EnrollmentsHelper.sharedInstance.enrollments = res
                let encoded = try? JSONEncoder().encode(res)
                UserDefaults.standard.set(encoded, forKey: "enrollments")
            } catch let error {
                presentAlert("Oops", "We can't seem to connect with our sever right now. Please restart the app and try again.")
                print(error)
                return
            }
        }
        semaphore.signal()
    }.resume()
    _ = semaphore.wait(timeout: .distantFuture)
    return
    
}

// MARK: - Enrollments
struct Enrollments: Codable {
    let PagingInfo: PagingInfo
    let Items: [Item]

    enum CodingKeys: String, CodingKey {
        case PagingInfo
        case Items 
    }

}

// MARK: - Item
struct Item: Codable {
    let OrgUnit: OrgUnit
    let Access: Access

    enum CodingKeys: String, CodingKey {
        case OrgUnit
        case Access
    }
}

// MARK: - Access
struct Access: Codable {
    let IsActive: Bool
    let StartDate, EndDate: String?
    let CanAccess: Bool

    enum CodingKeys: String, CodingKey {
        case IsActive
        case StartDate
        case EndDate
        case CanAccess
    }
}

// MARK: - OrgUnit
class OrgUnit: Codable {
    let Id: Int
    let `Type`: OrgUnit?
    let Name: String
    let Code: String?

    enum CodingKeys: String, CodingKey {
        case Id
        case `Type`
        case Name
        case Code
    }

    init(id: Int, type: OrgUnit?, name: String, code: String?) {
        self.Id = id
        self.Type = type
        self.Name = name
        self.Code = code
    }
}

// MARK: - PagingInfo
struct PagingInfo: Codable {
    let Bookmark: String
    let HasMoreItems: Bool

    enum CodingKeys: String, CodingKey {
        case Bookmark
        case HasMoreItems
    }
}
