//
//  RealmRoom.swift
//  Feelter
//
//  Created by 이정동 on 8/18/25.
//

import Foundation

import RealmSwift

final class RealmChatRoom: Object {
    @Persisted(primaryKey: true) var roomID: String
    @Persisted var participants: List<RealmMessageSender>
    @Persisted var lastChat: RealmChatMessage?
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    
    convenience init(
        roomID: String,
        participants: List<RealmMessageSender>,
        lastChat: RealmChatMessage? = nil,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.init()
        self.roomID = roomID
        self.participants = participants
        self.lastChat = lastChat
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    convenience init(from chatRoom: ChatRoom) {
        self.init()
        self.roomID = chatRoom.roomID
        
        let participants = List<RealmMessageSender>()
        participants.append(objectsIn: chatRoom.participants.map {
            RealmMessageSender(from: $0)
        })
        self.participants = participants
        
        self.lastChat = chatRoom.lastChat.map { RealmChatMessage(from: $0) }
        self.createdAt = chatRoom.createdAt
        self.updatedAt = chatRoom.updatedAt
    }
    
    func toDomain() -> ChatRoom {
        .init(
            roomID: roomID,
            participants: Array(participants).map { $0.toDomain() },
            lastChat: lastChat?.toDomain(),
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
