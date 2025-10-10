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
    @Persisted var lastMessage: String?
    @Persisted var isLastMessageFile: Bool
    @Persisted var unReadCount: Int
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    @Persisted var localUpdatedAt: Date
    
    convenience init(
        roomID: String,
        participants: List<RealmMessageSender>,
        lastMessage: String?,
        isLastMessageFile: Bool,
        unReadCount: Int = 0,
        createdAt: Date,
        updatedAt: Date,
        localUpdatedAt: Date
    ) {
        self.init()
        self.roomID = roomID
        self.participants = participants
        self.lastMessage = lastMessage
        self.isLastMessageFile = isLastMessageFile
        self.unReadCount = unReadCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.localUpdatedAt = localUpdatedAt
    }
    
    convenience init(from chatRoom: ChatRoom) {
        self.init()
        self.roomID = chatRoom.roomID
        
        let participants = List<RealmMessageSender>()
        participants.append(objectsIn: chatRoom.participants.map {
            RealmMessageSender(from: $0)
        })
        self.participants = participants
        
        self.lastMessage = chatRoom.lastMessage
        self.isLastMessageFile = chatRoom.isLastMessageFile
        self.unReadCount = chatRoom.unReadCount
        self.createdAt = chatRoom.createdAt
        self.updatedAt = chatRoom.updatedAt
        self.localUpdatedAt = chatRoom.localUpdatedAt
    }
    
    func toDomain() -> ChatRoom {
        .init(
            roomID: roomID,
            participants: Array(participants).map { $0.toDomain() },
            lastMessage: lastMessage,
            isLastMessageFile: isLastMessageFile,
            unReadCount: unReadCount,
            createdAt: createdAt,
            updatedAt: updatedAt,
            localUpdatedAt: localUpdatedAt
        )
    }
}
