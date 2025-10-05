//
//  MessageSenderResponseDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/17/25.
//

import Foundation

struct MessageSenderDTO: Decodable {
    let userID: String
    let nickname: String
    let name: String?
    let profileImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nickname = "nick"
        case name
        case profileImageURL = "profileImage"
    }
    
    func toDomain() -> MessageSender {
        .init(
            userID: userID,
            nickname: nickname,
            name: name,
            profileImageURL: profileImageURL
        )
    }
}
