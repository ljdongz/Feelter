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
    func updateChatRoomUpdatedAt(roomID: String, updatedAt: Date) throws

    
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
        return Array(realmRooms).map { $0.toDomain() }
    }
    
    func saveChatRooms(_ rooms: [ChatRoom]) throws {
        let realm = RealmStorage.shared.realm
        try realm.write {
            let realmRooms = rooms.map { RealmChatRoom(from: $0) }
            realm.add(realmRooms, update: .modified)
        }
    }
    
    func updateChatRoomUpdatedAt(roomID: String, updatedAt: Date) throws {
        let realm = RealmStorage.shared.realm
        try realm.write {
            let room = realm.object(
                ofType: RealmChatRoom.self,
                forPrimaryKey: roomID
            )
            room?.updatedAt = updatedAt
        }
    }
    
    // MARK: - 메시지 관련
    func fetchChatMessages(roomID: String) -> [ChatMessage] {
        let realm = RealmStorage.shared.realm
        let realmMessages = realm.objects(RealmChatMessage.self)
            .filter("roomID == %@", roomID)
            .sorted(byKeyPath: "createdAt", ascending: true)
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
