//
//  ChatLocalDataSource.swift
//  Feelter
//
//  Created by 이정동 on 8/18/25.
//

import Foundation

import RealmSwift

// TODO: 구조 고민
protocol ChatDataSource {
    // 채팅방 관련
    @MainActor
    func fetchChatRooms() -> [ChatRoom]
    @MainActor
    func saveChatRooms(_ rooms: [ChatRoom]) throws
    @MainActor
    func findChatRoom(opponentID: String) -> ChatRoom?
    @MainActor
    func updateChatRoom(
        roomID: String,
        updatedAt: Date,
        lastMessage: String,
        isLastMessageFile: Bool
    ) throws
    @MainActor
    func updateChatRoom(from apns: APNsPayload) throws

    
    // 메시지 관련
    @MainActor
    func fetchChatMessages(roomID: String) -> [ChatMessage]
    @MainActor
    func saveChatMessages(_ messages: [ChatMessage]) throws
}

struct ChatDataSourceImpl: ChatDataSource {
    
    // MARK: - 채팅방 관련
    func fetchChatRooms() -> [ChatRoom] {
        let realm = RealmStorage.shared.realm
        let realmRooms = realm.objects(RealmChatRoom.self)
            .where { $0.lastMessage != nil || $0.isLastMessageFile } // 채팅 메시지가 존재하는 채팅방만 가져오기
            .sorted(by: [
                .init(keyPath: "localUpdatedAt", ascending: false),
                .init(keyPath: "updatedAt", ascending: false)
            ])
        return Array(realmRooms).map { $0.toDomain() }
    }
    
    func saveChatRooms(_ rooms: [ChatRoom]) throws {
        let realm = RealmStorage.shared.realm
        try realm.write {
            let realmRooms = rooms.map { RealmChatRoom(from: $0) }
            realm.add(realmRooms, update: .modified)
        }
    }
    
    func findChatRoom(opponentID: String) -> ChatRoom? {
        let realm = RealmStorage.shared.realm
        let localRoom = realm.objects(RealmChatRoom.self)
            .where { $0.participants.userID == opponentID }
            .first
        return localRoom?.toDomain()
    }
    
    func updateChatRoom(
        roomID: String,
        updatedAt: Date,
        lastMessage: String,
        isLastMessageFile: Bool
    ) throws {
        let realm = RealmStorage.shared.realm
        try realm.write {
            let room = realm.object(
                ofType: RealmChatRoom.self,
                forPrimaryKey: roomID
            )
            room?.updatedAt = updatedAt
            room?.localUpdatedAt = updatedAt
            room?.lastMessage = lastMessage
            room?.isLastMessageFile = isLastMessageFile
        }
    }
    
    func updateChatRoom(from apns: APNsPayload) throws {
        let realm = RealmStorage.shared.realm
        try realm.write {
            let room = realm.object(
                ofType: RealmChatRoom.self,
                forPrimaryKey: apns.roomID
            )
            // TODO: APNs 응답 형식에 맞춰 수정하기
            room?.lastMessage = apns.aps.alert.body ?? "-"
            room?.isLastMessageFile = false
            room?.localUpdatedAt = Date()
        }
    }
    
    // MARK: - 메시지 관련
    func fetchChatMessages(roomID: String) -> [ChatMessage] {
        let realm = RealmStorage.shared.realm
        let realmMessages = realm.objects(RealmChatMessage.self)
            .where { $0.roomID == roomID }
            .sorted(by: \.createdAt, ascending: true)
        return Array(realmMessages).map { $0.toDomain() }
    }
    
    func saveChatMessages(_ messages: [ChatMessage]) throws {
        let realm = RealmStorage.shared.realm
        try realm.write {
            let realmMessages = messages.map { RealmChatMessage(from: $0) }
            realm.add(realmMessages, update: .modified)
        }
    }
}
