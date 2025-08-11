//
//  Filter.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

struct Filter: Hashable {
    let uuid = UUID()
    
    let filterID: String?
    let category: String?
    let title: String?
    let introduction: String?
    let description: String?
    let files: [String]?
    let creator: Profile?
    var isLiked: Bool?
    let likeCount: Int?
    let buyerCount: Int?
    let createdAt: String?
    let updatedAt: String?
}
