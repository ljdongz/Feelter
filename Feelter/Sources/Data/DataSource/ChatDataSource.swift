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
    @MainActor
    func fetchChatRooms() -> [ChatRoom]
    
    @MainActor
    func saveChatRooms(_ rooms: [ChatRoom]) throws
    
    @MainActor
    func fetchChatMessages(roomID: String) -> [ChatMessage]
    
    @MainActor
    func saveChatMessages(_ messages: [ChatMessage]) throws
}

struct ChatLocalDataSourceImpl: ChatDataSource {
    
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
