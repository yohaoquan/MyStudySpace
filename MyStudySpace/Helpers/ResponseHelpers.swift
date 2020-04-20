//
//  ResponseStructs.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/19/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation

// MARK: - Structs
struct URLResponse: Codable { // or Decodable
    let status: String
    let url: String
}


struct WhoamiResponse: Codable {
    let Identifier: String
    let FirstName: String
    let LastName: String
    let UniqueName: String
    let ProfileIdentifier: String
}


// MARK: - Functions
func convertJSONToDictionary(data: Data) -> [String: Any]? {
    do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    } catch {
        print(error.localizedDescription)
    }
    return nil
}


