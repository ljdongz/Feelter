//
//  ChatRepository.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

protocol ChatRepository {
    func createRoom(opponentID: String) async throws -> ChatRoom
    func fetchRooms() async throws -> [ChatRoom]
    func sendMessage(to roomID: String, message: SendMessage) async throws -> ChatMessage
    func fetchMessages(from roomID: String, after: String?) async throws -> [ChatMessage]
}
