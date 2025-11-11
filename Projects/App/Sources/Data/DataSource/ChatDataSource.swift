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
    func fetchChatRooms() -> [ChatRoom]
    func saveChatRooms(_ rooms: [ChatRoom]) throws
    func saveChatRoom(_ room: ChatRoom) throws
    func findChatRoom(opponentID: String) -> ChatRoom?
    func findChatRoom(roomID: String) -> ChatRoom?
    func updateChatRoom(
        roomID: String,
        updatedAt: Date,
        lastMessage: String
    ) throws
    func updateChatRoom(from apns: APNsPayload) throws
    func updateUnReadCount(roomID: String, unReadCount: Int) throws

    
    // 메시지 관련
    func fetchChatMessages(
        roomID: String,
        before lastMessageAt: Date,
        limit: Int
    ) -> [ChatMessage]
    func saveChatMessages(_ messages: [ChatMessage]) throws
}

struct ChatDataSourceImpl: ChatDataSource {
    
    // MARK: - 채팅방 관련
    func fetchChatRooms() -> [ChatRoom] {
        let realm = try! Realm()
        let realmRooms = realm.objects(RealmChatRoom.self)
            .where { $0.lastMessage != nil } // 채팅 메시지가 존재하는 채팅방만 가져오기
            .sorted(by: [
                .init(keyPath: "localUpdatedAt", ascending: false),
                .init(keyPath: "updatedAt", ascending: false)
            ])
        return Array(realmRooms).map { $0.toDomain() }
    }
    
    func saveChatRooms(_ rooms: [ChatRoom]) throws {
        let realm = try! Realm()
        try realm.write {
            let realmRooms = rooms.map { RealmChatRoom(from: $0) }
            realm.add(realmRooms, update: .modified)
        }
    }
    
    func saveChatRoom(_ room: ChatRoom) throws {
        let realm = try! Realm()
        try realm.write {
            let realmRoom = RealmChatRoom(from: room)
            realm.add(realmRoom, update: .modified)
        }
    }
    
    func findChatRoom(opponentID: String) -> ChatRoom? {
        let realm = try! Realm()
        let localRoom = realm.objects(RealmChatRoom.self)
            .where { $0.participants.userID == opponentID }
            .first
        return localRoom?.toDomain()
    }
    
    func findChatRoom(roomID: String) -> ChatRoom? {
        let realm = try! Realm()
        let localRoom = realm.object(ofType: RealmChatRoom.self, forPrimaryKey: roomID)
        return localRoom?.toDomain()
    }
    
    func updateChatRoom(
        roomID: String,
        updatedAt: Date,
        lastMessage: String
    ) throws {
        let realm = try! Realm()
        try realm.write {
            let room = realm.object(
                ofType: RealmChatRoom.self,
                forPrimaryKey: roomID
            )
            room?.updatedAt = updatedAt
            room?.localUpdatedAt = updatedAt
            room?.lastMessage = lastMessage
        }
    }
    
    func updateChatRoom(from apns: APNsPayload) throws {
        let realm = try! Realm()
        try realm.write {
            let room = realm.object(
                ofType: RealmChatRoom.self,
                forPrimaryKey: apns.roomID
            )
            // TODO: APNs 응답 형식에 맞춰 수정하기
            room?.lastMessage = apns.aps.alert.body ?? ""
            room?.localUpdatedAt = Date()
            room?.unReadCount += 1
        }
    }
    
    func updateUnReadCount(roomID: String, unReadCount: Int) throws {
        let realm = try! Realm()
        try realm.write {
            let room = realm.object(
                ofType: RealmChatRoom.self,
                forPrimaryKey: roomID
            )
            
            room?.unReadCount = unReadCount
        }
    }
    
    // MARK: - 메시지 관련
    func fetchChatMessages(
        roomID: String,
        before lastMessageAt: Date,
        limit: Int
    ) -> [ChatMessage] {
        let realm = try! Realm()
        let realmMessages = realm.objects(RealmChatMessage.self)
            .where { $0.roomID == roomID && $0.createdAt < lastMessageAt }
            .sorted(by: \.createdAt, ascending: true)
            .suffix(limit)
        return Array(realmMessages).map { $0.toDomain() }
    }
    
    func saveChatMessages(_ messages: [ChatMessage]) throws {
        let realm = try! Realm()
        try realm.write {
            let realmMessages = messages.map { RealmChatMessage(from: $0) }
            realm.add(realmMessages, update: .modified)
        }
    }
}
