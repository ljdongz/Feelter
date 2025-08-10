//
//  FilterDetailResponseDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import Foundation

struct FilterDetailResponseDTO: Decodable {
    let filterID: String
    let category: String
    let title: String
    let description: String
    let imageURLs: [String]
    let price: Int
    let author: ProfileDTO
    let photoMetadata: PhotoMetadataDTO?
    let attribute: FilterAttributeDTO
    let isLiked: Bool
    let isDownloaded: Bool
    let likeCount: Int
    let buyerCount: Int
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case filterID = "filter_id"
        case category
        case title
        case description
        case imageURLs = "files"
        case price
        case author = "creator"
        case photoMetadata
        case attribute = "filterValues"
        case isLiked = "is_liked"
        case isDownloaded = "is_downloaded"
        case likeCount = "like_count"
        case buyerCount = "buyer_count"
        case createdAt
        case updatedAt
    }
    
    func toDomain() -> FilterDetail {
        .init(
            id: filterID,
            category: category,
            title: title,
            description: description,
            imageURLs: imageURLs,
            price: price,
            author: author.toDomain(),
            photoMetadata: photoMetadata?.toDomain(),
            attribute: attribute.toDomain(),
            isLiked: isLiked,
            isDownloaded: isDownloaded,
            likeCount: likeCount,
            buyerCount: buyerCount,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
