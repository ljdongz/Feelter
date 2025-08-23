//
//  ChatRepository.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

protocol ChatRepository {
    // 소켓 관련
    func connectRoom(roomID: String, receiveMessage: @escaping (ChatMessage) -> Void)
    func disconnectRoom()
    
    // 채팅방 관련
    func createRoom(opponentID: String) async throws -> ChatRoom
    func fetchRooms() async throws -> [ChatRoom]
    func fetchLocalRooms() async -> [ChatRoom]
    func updateRoom(apnsPayload: APNsPayload) async throws
    
    // 메시지 관련
    func sendMessage(to roomID: String, message: SendMessage) async throws -> ChatMessage
    func fetchMessages(from roomID: String, after: String?) async throws -> [ChatMessage]
    func fetchLocalMessages(
        from roomID: String,
        before lastMessageAt: Date
    ) async -> [ChatMessage]
    func saveMessage(_ message: ChatMessage) async throws -> ChatMessage
}
