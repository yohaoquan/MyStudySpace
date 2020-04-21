//
//  CoursesHelper.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/20/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation



func getGrades(orgUnit: OrgUnit){
    var res = Grades()
    if !LoginHelper.sharedInstance.loginState!.isOnline {
        let data = UserDefaults.standard.data(forKey: orgUnit.Name+String(orgUnit.Id))
        if data == nil {
            let empty = try! JSONEncoder().encode(Grades())
            UserDefaults.standard.set(empty, forKey: orgUnit.Name+String(orgUnit.Id))
        }
        return
    }
    let url1 = generateURLForRoute(route: "/d2l/api/le/1.34/" + String(orgUnit.Id) + "/grades/values/myGradeValues/", method: .GET)
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
                res = try JSONDecoder().decode(Grades.self, from: data)
                let encoded = try? JSONEncoder().encode(res)
                UserDefaults.standard.set(encoded, forKey: orgUnit.Name+String(orgUnit.Id))
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

//   let grades = try? newJSONDecoder().decode(Grades.self, from: jsonData)

import Foundation

// MARK: - Grade
struct Grade: Codable {
    var PointsNumerator: Double
    var PointsDenominator: Int
    var WeightedNumerator, WeightedDenominator: Double
    var GradeObjectIdentifier, GradeObjectName: String
    var GradeObjectType: Int
    var GradeObjectTypeName: GradeObjectTypeName
    var DisplayedGrade: String
    var Comments, PrivateComments: Comments
    var LastModified: String
    var LastModifiedBy, ReleasedDate: String?
    
    enum CodingKeys: String, CodingKey {
        case PointsNumerator
        case PointsDenominator
        case WeightedNumerator
        case WeightedDenominator
        case GradeObjectIdentifier
        case GradeObjectName
        case GradeObjectType
        case GradeObjectTypeName
        case DisplayedGrade
        case Comments
        case PrivateComments
        case LastModified
        case LastModifiedBy
        case ReleasedDate
    }
}

// MARK: - Comments
struct Comments: Codable {
    var Text, Html: String
    
    enum CodingKeys: String, CodingKey {
        case Text
        case Html
    }
}

enum GradeObjectTypeName: String, Codable {
    case Category = "Category"
    case Numeric = "Numeric"
}

typealias Grades = [Grade]
