//
//  LikeStatusDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/11/25.
//

import Foundation

struct LikeStatusDTO: Codable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}
