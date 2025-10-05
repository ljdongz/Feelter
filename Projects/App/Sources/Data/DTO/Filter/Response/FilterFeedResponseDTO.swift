//
//  FilterListResponseDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import Foundation

struct FilterFeedResponseDTO: Decodable {
    let filters: [FilterDTO]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case filters = "data"
        case nextCursor = "next_cursor"
    }
    
    func toDomain() -> FilterFeed {
        return .init(
            filters: filters.map { $0.toDomain() },
            nextCursor: nextCursor
        )
    }
}
