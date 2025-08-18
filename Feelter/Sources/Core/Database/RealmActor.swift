//
//  RealmActor.swift
//  Feelter
//
//  Created by 이정동 on 8/18/25.
//

import Foundation

import RealmSwift

@globalActor
actor RealmActor: GlobalActor {
    static let shared = RealmActor()
    
    private var realm: Realm?
    
    private init() {
        // 빈 초기화, lazy하게 Realm 생성
    }
    
    private func getRealm() async throws -> Realm {
        if realm == nil {
            realm = try await Realm(actor: RealmActor.shared)
        }
        return realm!
    }
    
    // MARK: - ChatRoom Operations
    func fetchChatRooms() async throws -> [ChatRoom] {
        let realm = try await getRealm()
        let realmRooms = realm.objects(RealmChatRoom.self)
        return Array(realmRooms).map { $0.toDomain() }
    }
    
    func saveChatRooms(_ rooms: [ChatRoom]) async throws {
        let realm = try await getRealm()
        try realm.write {
            let realmRooms = rooms.map { RealmChatRoom(from: $0) }
            realm.add(realmRooms, update: .modified)
        }
    }
    
    // MARK: - ChatMessage Operations
    func fetchChatMessages(roomID: String) async throws -> [ChatMessage] {
        let realm = try await getRealm()
        let realmMessages = realm.objects(RealmChatMessage.self)
            .filter("roomID == %@", roomID)
            .sorted(byKeyPath: "createdAt", ascending: true)
        return Array(realmMessages).map { $0.toDomain() }
    }
    
    func saveChatMessages(_ messages: [ChatMessage]) async throws {
        let realm = try await getRealm()
        try realm.write {
            let realmMessages = messages.map { RealmChatMessage(from: $0) }
            realm.add(realmMessages, update: .modified)
        }
    }
}

extension Realm: @retroactive @unchecked Sendable {}
