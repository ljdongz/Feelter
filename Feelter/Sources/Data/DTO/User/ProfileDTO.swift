//
//  ProfileDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

struct ProfileDTO: Codable {
    let userID: String?
    let name: String?
    let nickname: String?
    let profileImageURL: String?
    let phoneNumber: String?
    let hashTags: [String]?
    let introduction: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name
        case nickname = "nick"
        case profileImageURL = "profileImage"
        case phoneNumber = "phoneNum"
        case hashTags
        case introduction
        case description
    }
}
