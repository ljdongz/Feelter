//
//  ChatRepositoryImpl.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

struct ChatRepositoryImpl: ChatRepository {
    
    private let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
    
    func createRoom(opponentID: String) async throws -> ChatRoom {
        let requestDTO = CreateChatRoomRequestDTO(opponentID: opponentID)
        
        let response = try await networkProvider.request(
            endpoint: ChatAPI.createRoom(requestDTO),
            type: ChatRoomResponseDTO.self
        )
        
        return response.toDomain()
    }
    
    func fetchRooms() async throws -> [ChatRoom] {
        let response = try await networkProvider.request(
            endpoint: ChatAPI.fetchRooms,
            type: ChatRoomListResponseDTO.self
        )
        
        return response.rooms.map { $0.toDomain() }
    }
    
    func sendMessage(to roomID: String, message: SendMessage) async throws -> ChatMessage {
        let requestDTO = SendChatMessageRequestDTO(
            content: message.content,
            fileURLs: message.fileURLs
        )
        
        let response = try await networkProvider.request(
            endpoint: ChatAPI.sendMessage(roomID: roomID, requestDTO),
            type: ChatMessageResponseDTO.self
        )
        
        return response.toDomain()
    }
    
    func fetchMessages(from roomID: String, after: String?) async throws -> [ChatMessage] {
        let response = try await networkProvider.request(
            endpoint: ChatAPI.fetchMessages(roomID: roomID, after: after),
            type: ChatMessageListResponseDTO.self
        )
        
        return response.messages.map { $0.toDomain() }
    }
}
