//
//  ChatRepositoryImpl.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

final class ChatRepositoryImpl: ChatRepository {
    
    private let networkProvider: NetworkProvider
    private let socketProvider: SocketProvider
    private let chatDataSource: ChatDataSource
    
    private var chatRooms: [ChatRoom] = []
    
    init(
        networkProvider: NetworkProvider,
        socketProvider: SocketProvider,
        chatDataSource: ChatDataSource
    ) {
        self.networkProvider = networkProvider
        self.socketProvider = socketProvider
        self.chatDataSource = chatDataSource
    }
    
    // MARK: - 소켓 관련
    func connectRoom(roomID: String, receiveMessage: @escaping (ChatMessage) -> Void) {
        socketProvider.connect(roomID: roomID, receiveMessage: receiveMessage)
    }
    
    func disconnectRoom() {
        socketProvider.disconnect()
    }
    
    // MARK: - 채팅방 관련
    func createRoom(opponentID: String) async throws -> ChatRoom {
        let requestDTO = CreateChatRoomRequestDTO(opponentID: opponentID)
        
        let response = try await networkProvider.request(
            endpoint: ChatAPI.createRoom(requestDTO),
            type: ChatRoomResponseDTO.self
        )
        
        return response.toDomain()
    }
    
    func fetchRooms() async throws -> [ChatRoom] {
        // 1. 서버에서 최신 채팅방 목록 가져오기
        let response = try await networkProvider.request(
            endpoint: ChatAPI.fetchRooms,
            type: ChatRoomListResponseDTO.self
        )
        
        // 2. 대화 내역이 있는 데이터만 Domain 모델로 변환
        let serverRooms = response.rooms
            .filter { $0.lastChat != nil }
            .map { $0.toDomain() }
        
        // 3. 로컬 데이터와 비교하여 업데이트 필요한 방 찾기
        let localRoomsDict = Dictionary(
            uniqueKeysWithValues: chatRooms.map { ($0.roomID, $0) }
        )
        let roomsToUpdate = findRoomsNeedingUpdate(
            serverRooms: serverRooms,
            localRoomsDict: localRoomsDict
        )
        
        // 4. 변경된 채팅방들의 메시지 동기화
        await syncMessagesForUpdatedRooms(roomsToUpdate, localRoomsDict: localRoomsDict)
        
        // 5. 채팅방 목록 저장 및 반환
        try await chatDataSource.saveChatRooms(serverRooms)
        self.chatRooms = serverRooms
        return serverRooms
    }
    
    func fetchLocalRooms() async -> [ChatRoom] {
        let rooms = await chatDataSource.fetchChatRooms()
        self.chatRooms = rooms
        return rooms
    }
    
    func updateRoom(apnsPayload: APNsPayload) async throws {
        if socketProvider.isConnected(roomID: apnsPayload.roomID) { return }
        try await chatDataSource.updateChatRoom(from: apnsPayload)
    }
    
    // MARK: - 메시지 관련
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
        
        let messages = response.messages.map { $0.toDomain() }
        
        try await chatDataSource.saveChatMessages(messages)
        
        if let lastChat = messages.last {
            try await chatDataSource.updateChatRoom(
                roomID: roomID,
                updatedAt: lastChat.updatedAt,
                lastMessage: lastChat.content,
                isLastMessageFile: lastChat.fileURLs.isEmpty
            )
            
            chatRooms = await chatDataSource.fetchChatRooms()
        }
            
        return messages
    }
    
    func fetchLocalMessages(from roomID: String) async -> [ChatMessage] {
        await chatDataSource.fetchChatMessages(roomID: roomID)
    }
    
    func saveMessage(_ message: ChatMessage) async throws -> ChatMessage {
        try await chatDataSource.saveChatMessages([message])
        
        try await chatDataSource.updateChatRoom(
            roomID: message.roomID,
            updatedAt: message.createdAt,
            lastMessage: message.content,
            isLastMessageFile: message.fileURLs.isEmpty
        )
        
        if let index = chatRooms.firstIndex(where: { $0.roomID == message.roomID }) {
            chatRooms[index] = .init(
                roomID: message.roomID,
                participants: chatRooms[index].participants,
                lastMessage: message.content,
                isLastMessageFile: message.fileURLs.isEmpty,
                createdAt: chatRooms[index].createdAt,
                updatedAt: message.createdAt,
                localUpdatedAt: message.createdAt
            )
        }
        
        return message
    }
}

// MARK: - 채팅방 목록 DB 최신화

extension ChatRepositoryImpl {
    
    private func findRoomsNeedingUpdate(
        serverRooms: [ChatRoom],
        localRoomsDict: [String: ChatRoom]
    ) -> [ChatRoom] {
        return serverRooms.filter { serverRoom in
            guard let localRoom = localRoomsDict[serverRoom.roomID] else {
                // 새로운 채팅방
                return true
            }
            
            // 채팅방 업데이트 날짜 비교
            return serverRoom.updatedAt != localRoom.updatedAt
        }
    }
    
    private func syncMessagesForUpdatedRooms(
        _ roomsToUpdate: [ChatRoom],
        localRoomsDict: [String: ChatRoom]
    ) async {
        await withTaskGroup(of: Void.self) { group in
            for room in roomsToUpdate {
                group.addTask { [weak self] in
                    await self?.syncMessagesForRoom(
                        room,
                        localRoom: localRoomsDict[room.roomID]
                    )
                }
            }
        }
    }
    
    private func syncMessagesForRoom(_ room: ChatRoom, localRoom: ChatRoom?) async {
        do {
            // 로컬 채팅방 업데이트된 날짜 기준으로 after 파라미터 설정
            let lastMessageTime = localRoom?.updatedAt
            let afterParameter = lastMessageTime.map {
                UTCDateFormatter.shared.string(from: $0)
            }
            
            let newMessages = try await fetchMessages(
                from: room.roomID,
                after: afterParameter
            )
            
            try await chatDataSource.saveChatMessages(newMessages)
            
        } catch {
            print("메시지 동기화 실패 - 채팅방 ID: \(room.roomID), 에러: \(error)")
        }
    }
}
