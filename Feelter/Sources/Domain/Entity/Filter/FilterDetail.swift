//
//  FilterDetail.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import Foundation

struct FilterDetail {
    let id: String
    let category: String
    let title: String
    let description: String
    let imageURLs: [String]
    let price: Int
    let author: Profile
    let photoMetadata: PhotoMetadata?
    let attribute: FilterAttribute
    let isLiked: Bool
    let isDownloaded: Bool
    let likeCount: Int
    let buyerCount: Int
    let createdAt: Date
    let updatedAt: Date
}
