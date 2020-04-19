//
//  ResponseStructs.swift
//  MyStudySpace
//
//  Created by Aaron You on 4/19/20.
//  Copyright © 2020 Haoquan you. All rights reserved.
//

import Foundation


struct Response: Codable { // or Decodable
    let status: String
    let url: String
}
