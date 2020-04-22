//
//  DueDropHelper.swift
//  MyStudySpace
//
//  Created by Xiaohu He on 2020-04-21.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation
import UIKit

class DueDropHelper{
    static let sharedInstance = DueDropHelper()
    var Dropbox = Dropboxes()
}

func refreshDrops(orgUnit: OrgUnit){
    var res = Dropboxes()
    if !LoginHelper.sharedInstance.loginState!.isOnline {
        let data = UserDefaults.standard.data(forKey: orgUnit.Name + "drop")
        if data == nil {
            let empty = try! JSONEncoder().encode(Dropboxes())
            UserDefaults.standard.set(empty, forKey: orgUnit.Name + "drop")
        }
        return
    }
    let url1 = generateURLForRoute(route:  "/d2l/api/le/1.34/\(String(orgUnit.Id))/dropbox/folders/", method: .GET)
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
    var someDueDate: [DuedateItem] = []
    print(String(describing: accessURL?.url))
    URLSession.shared.dataTask(with: accessURL!.url!) { data, response, error in
        if let data = data {
            do {
                print("Got data!")
                let dataFromQuiz = UserDefaults.standard.data(forKey: orgUnit.Name + "quizdue")
                let resFromQuiz = try! JSONDecoder().decode([DuedateItem].self, from: dataFromQuiz!)
                for item in resFromQuiz {
                    someDueDate.append(DuedateItem(name:item.name, type: item.type, time:item.time))
                }
                res = try JSONDecoder().decode(Dropboxes.self, from: data)
                for item in res{
                    if item.DueDate == nil{
                        continue
                    }
                    someDueDate.append(DuedateItem(name:item.Name, type: 1, time:item.DueDate!))
                }
                let encoded = try? JSONEncoder().encode(someDueDate)
                UserDefaults.standard.set(encoded, forKey: orgUnit.Name + "drop")
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



// MARK: - Dropbox
struct Dropbox: Codable {
    var Id: Int
    var CategoryId: Int?
    var Name: String
    var CustomInstructions: CustomInstructions
    var Attachments: [Attachment]
    var TotalFiles, UnreadFiles, FlaggedFiles, TotalUsers: Int
    var TotalUsersWithSubmissions, TotalUsersWithFeedback: Int
    var Availability: Availability?
    var IsHidden: Bool
    var Assessment: Assessment
    var DropboxType: Int
    var GroupTypeId: Int?
    var DueDate: String?
    var DisplayInCalendar: Bool
    var NotificationEmail: String?
    var LinkAttachments: [LinkAttachment]
    var ActivityId: String
    var IsAnonymous: Bool
    var SubmissionType, CompletionType: Int

    enum CodingKeys: String, CodingKey {
        case Id
        case CategoryId
        case Name
        case CustomInstructions
        case Attachments
        case TotalFiles
        case UnreadFiles
        case FlaggedFiles
        case TotalUsers
        case TotalUsersWithSubmissions
        case TotalUsersWithFeedback
        case Availability
        case IsHidden
        case Assessment
        case DropboxType
        case GroupTypeId
        case DueDate
        case DisplayInCalendar
        case NotificationEmail
        case LinkAttachments
        case ActivityId
        case IsAnonymous
        case SubmissionType
        case CompletionType
    }
}

// MARK: - Assessment
struct Assessment: Codable {
    var ScoreDenominator: Int?
    var Rubrics: [Rubric]?

    enum CodingKeys: String, CodingKey {
        case ScoreDenominator
        case Rubrics
    }
}

// MARK: - Rubric
struct Rubric: Codable {
    var RubricId: Int
    var Name: String
    var RubricDescription: CustomInstructions
    var RubricType, ScoringMethod: Int
    var IsScoreVisibleToAssessedUsers: Bool
    var CriteriaGroups: [CriteriaGroup]
    var OverallLevels: [OverallLevel]

    enum CodingKeys: String, CodingKey {
        case RubricId
        case Name
        case RubricDescription
        case RubricType
        case ScoringMethod
        case IsScoreVisibleToAssessedUsers
        case CriteriaGroups
        case OverallLevels
    }
}

// MARK: - CriteriaGroup
struct CriteriaGroup: Codable {
    var Name: String
    var Levels: [Level]
    var Criteria: [Criterion]
    var LevelSetId: Int

    enum CodingKeys: String, CodingKey {
        case Name
        case Levels
        case Criteria
        case LevelSetId
    }
}

// MARK: - Criterion
struct Criterion: Codable {
    var Id: Int
    var Name: String
    var Cells: [Cell]

    enum CodingKeys: String, CodingKey {
        case Id
        case Name
        case Cells
    }
}

// MARK: - Cell
struct Cell: Codable {
    var Feedback, CellDescription: CustomInstructions
    var Points: Int?
    var LevelId: Int

    enum CodingKeys: String, CodingKey {
        case Feedback
        case CellDescription
        case Points
        case LevelId
    }
}

// MARK: - CustomInstructions
struct CustomInstructions: Codable {
    var Text, Html: String

    enum CodingKeys: String, CodingKey {
        case Text
        case Html
    }
}

// MARK: - Level
struct Level: Codable {
    var Id: Int
    var Name: String
    var Points: Int

    enum CodingKeys: String, CodingKey {
        case Id
        case Name
        case Points
    }
}

// MARK: - OverallLevel
struct OverallLevel: Codable {
    var Id: Int
    var Name: String
    var RangeStart: Int
    var OverallLevelDescription, Feedback: CustomInstructions

    enum CodingKeys: String, CodingKey {
        case Id
        case Name
        case RangeStart
        case OverallLevelDescription
        case Feedback
    }
}

// MARK: - Attachment
struct Attachment: Codable {
    var FileId: Int
    var FileName: String
    var Size: Int

    enum CodingKeys: String, CodingKey {
        case FileId
        case FileName
        case Size
    }
}

// MARK: - Availability
struct Availability: Codable {
    var StartDate, EndDate: String

    enum CodingKeys: String, CodingKey {
        case StartDate
        case EndDate
    }
}

// MARK: - LinkAttachment
struct LinkAttachment: Codable {
    var LinkId: Int
    var LinkName: String
    var Href: String

    enum CodingKeys: String, CodingKey {
        case LinkId
        case LinkName
        case Href
    }
}

typealias Dropboxes = [Dropbox]
