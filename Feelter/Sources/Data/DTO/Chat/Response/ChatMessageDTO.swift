//
//  ChatMessageDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

struct ChatMessageResponseDTO: Decodable {
    let chatID: String
    let roomID: String
    let content: String
    let sender: ProfileDTO
    let fileURLs: [String]
    
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case roomID = "room_id"
        case content
        case sender
        case fileURLs = "files"
        case createdAt
        case updatedAt
    }
    
    func toDomain() -> ChatMessage {
        .init(
            chatID: chatID,
            roomID: roomID,
            content: content,
            fileURLs: fileURLs,
            sender: sender.toDomain(),
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
