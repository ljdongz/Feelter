//
//  FilterDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

struct FilterDTO: Codable {
    let filterID: String?
    let category: String?
    let title: String?
    let description: String?
    let files: [String]?
    let creator: ProfileDTO?
    
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case filterID = "filter_id"
        case category
        case title
        case description
        case files
        case creator
        case createdAt
        case updatedAt
    }
}
