//
//  ChatRoomDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

struct ChatRoomResponseDTO: Decodable {
    let roomID: String
    
    let participants: [ProfileDTO]
    let lastChat: ChatMessageResponseDTO?
    
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case participants
        case lastChat
        case createdAt
        case updatedAt
    }
    
    func toDomain() -> ChatRoom {
        .init(
            roomID: roomID,
            participants: participants.map { $0.toDomain() },
            lastChat: lastChat?.toDomain(),
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
