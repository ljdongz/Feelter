//
//  RealmChatMessage.swift
//  Feelter
//
//  Created by 이정동 on 8/18/25.
//

import Foundation

import RealmSwift

final class RealmChatMessage: Object {
    @Persisted(primaryKey: true) var chatID: String
    @Persisted(indexed: true) var roomID: String
    @Persisted var content: String
    @Persisted var fileURLs: List<String>
    @Persisted var sender: RealmMessageSender?
    @Persisted(indexed: true) var createdAt: Date
    @Persisted var updatedAt: Date
    
    convenience init(
        chatID: String,
        roomID: String,
        content: String,
        fileURLs: List<String>,
        sender: RealmMessageSender? = nil,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.init()
        self.chatID = chatID
        self.roomID = roomID
        self.content = content
        self.fileURLs = fileURLs
        self.sender = sender
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    convenience init(from chatMessage: ChatMessage) {
        self.init()
        self.chatID = chatMessage.chatID
        self.roomID = chatMessage.roomID
        self.content = chatMessage.content
        
        let fileURLs = List<String>()
        fileURLs.append(objectsIn: chatMessage.fileURLs)
        self.fileURLs = fileURLs
        
        self.sender = RealmMessageSender(from: chatMessage.sender)
        self.createdAt = chatMessage.createdAt
        self.updatedAt = chatMessage.updatedAt
    }
    
    func toDomain() -> ChatMessage {
        .init(
            chatID: chatID,
            roomID: roomID,
            content: content,
            fileURLs: Array(fileURLs),
            sender: sender?.toDomain() ?? .init(userID: "", nickname: "", name: nil, profileImageURL: nil),
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
