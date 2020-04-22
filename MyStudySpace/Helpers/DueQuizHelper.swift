//
//  DueHelper.swift
//  MyStudySpace
//
//  Created by Xiaohu He on 2020-04-21.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation
import UIKit

class DueQuizHelper {
    static let sharedInstance = DueQuizHelper()
    var quizzes = Quizzes(Objects: [], Next: "")
}

func refreshQuizzes(orgUnit: OrgUnit){
    var res = Quizzes(Objects: [], Next: "")
    if !LoginHelper.sharedInstance.loginState!.isOnline {
        let data = UserDefaults.standard.data(forKey: orgUnit.Name + "quizdue")
        if data == nil {
            let empty = try! JSONEncoder().encode(Quizzes(Objects: [], Next: ""))
            UserDefaults.standard.set(empty, forKey: orgUnit.Name+String(orgUnit.Id))
        }
        return
    }
    let url1 = generateURLForRoute(route: "/d2l/api/le/1.34/\(String(orgUnit.Id))/quizzes/", method: .GET)
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
    print(String(describing: accessURL?.url))
    URLSession.shared.dataTask(with: accessURL!.url!) { data, response, error in
        if let data = data {
            do {
                print("Got data!")
                res = try JSONDecoder().decode(Quizzes.self, from: data)
                var someDuedate: [DuedateItem] = []
                for item in res.Objects{
                    someDuedate.append(DuedateItem(name: item.Name , type: 0, time: item.StartDate))
                }
                let encoded = try? JSONEncoder().encode(someDuedate)
                UserDefaults.standard.set(encoded, forKey: orgUnit.Name + "quizdue")
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

// MARK: - Quizzes
struct Quizzes: Codable {
    var Objects: [Object]
    var Next: String?

    enum CodingKeys: String, CodingKey {
        case Objects
        case Next
    }
}

// MARK: - Object
struct Object: Codable {
    var QuizId: Int
    var Name: String
    var AutoExportToGrades, IsActive: Bool
    var GradeItemId: Int?
    var IsAutoSetGraded: Bool
    var Instructions, Description, Header, Footer: Description?
    var StartDate, EndDate: String
    var DueDate: String?
    var DisplayInCalendar: Bool
    var SortOrder: Int
    var SubmissionTimeLimit: SubmissionTimeLimit
    var SubmissionGracePeriod: Int
    var LateSubmissionInfo: LateSubmissionInfo?
    var AttemptsAllowed: AttemptsAllowed
    var Password: String?
    var AllowHints, DisableRightClick, DisablePagerAndAlerts: Bool
    var RestrictIPAddressRange: [String]?
    var NotificationEmail: String?
    var CalcTypeId, CategoryId: Int?	

    enum CodingKeys: String, CodingKey {
        case QuizId
        case Name
        case AutoExportToGrades
        case IsActive
        case GradeItemId
        case IsAutoSetGraded
        case Instructions
        case Description
        case Header
        case Footer
        case StartDate
        case EndDate
        case DueDate
        case DisplayInCalendar
        case SortOrder
        case SubmissionTimeLimit
        case SubmissionGracePeriod
        case LateSubmissionInfo
        case AttemptsAllowed
        case Password
        case AllowHints
        case DisableRightClick
        case DisablePagerAndAlerts
        case RestrictIPAddressRange
        case NotificationEmail
        case CalcTypeId
        case CategoryId
    }
}

// MARK: - AttemptsAllowed
struct AttemptsAllowed: Codable {
    var IsUnlimited: Bool
    var NumberOfAttemptsAllowed: Int?

    enum CodingKeys: String, CodingKey {
        case IsUnlimited
        case NumberOfAttemptsAllowed
    }
}

// MARK: - Description
struct Description: Codable {
    var Text: Text?
    var IsDisplayed: Bool?

    enum CodingKeys: String, CodingKey {
        case Text
        case IsDisplayed
    }
}

// MARK: - Text
struct Text: Codable {
    var Text, Html: String

    enum CodingKeys: String, CodingKey {
        case Text
        case Html
    }
}

// MARK: - LateSubmissionInfo
struct LateSubmissionInfo: Codable {
    var LateSubmissionOption, LateLimitMinutes: Int?

    enum CodingKeys: String, CodingKey {
        case LateSubmissionOption
        case LateLimitMinutes
    }
}

// MARK: - SubmissionTimeLimit
struct SubmissionTimeLimit: Codable {
    var IsEnforced, ShowClock: Bool
    var TimeLimitValue: Int

    enum CodingKeys: String, CodingKey {
        case IsEnforced
        case ShowClock
        case TimeLimitValue
    }
}

struct DuedateItem: Codable {
    var name: String
    var type: Int //0 - Quiz, 1 - Dropbox
    var time: String
}


