//
//  ChatRoomDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

struct ChatRoomResponseDTO: Decodable {
    let roomID: String
    
    let participants: [MessageSenderDTO]
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
        let isLastMessageFile = !(lastChat?.fileURLs.isEmpty ?? true)
        
        return .init(
            roomID: roomID,
            participants: participants.map { $0.toDomain() },
            lastMessage: lastChat?.content,
            isLastMessageFile: isLastMessageFile,
            createdAt: UTCDateFormatter.shared.date(from: createdAt) ?? Date(),
            updatedAt: UTCDateFormatter.shared.date(from: updatedAt) ?? Date(),
            localUpdatedAt: UTCDateFormatter.shared.date(from: lastChat?.createdAt ?? "") ?? Date()
        )
    }
}
