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
    let isLiked: Bool?
    let likeCount: Int?
    let buyerCount: Int?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case filterID = "filter_id"
        case category
        case title
        case description
        case files
        case creator
        case isLiked = "is_liked"
        case likeCount = "like_count"
        case buyerCount = "buyer_count"
        case createdAt
        case updatedAt
    }
    
    func toDomain() -> Filter {
        return .init(
            filterID: filterID,
            category: category,
            title: title,
            description: description,
            files: files,
            creator: creator?.toDomain(),
            isLiked: isLiked,
            likeCount: likeCount,
            buyerCount: buyerCount,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
