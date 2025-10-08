//
//  SocketIOProviderImpl.swift
//  Feelter
//
//  Created by 이정동 on 8/17/25.
//

import Foundation

import SocketIO

import FTStorageInterface

final class SocketProviderImpl: SocketProvider {
    
    private let tokenManager: TokenManager
    
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    private var receiveMessageHandler: ((ChatMessage) -> Void)?
    
    private var connectRoomID: String?
    
    init(tokenManager: TokenManager) {
        self.tokenManager = tokenManager
    }
    
    func connect(roomID: String, receiveMessage: @escaping ((ChatMessage) -> Void)) {
        guard let accessToken = tokenManager.accessToken else {
            print("No access token available")
            return
        }
        
        // 소켓 매니저 설정 (인증 포함)
        let config: SocketIOClientConfiguration = [
            .log(false),
            .compress,
            .extraHeaders([
                "Authorization": "\(accessToken)",
                "SeSACKey" : AppConfiguration.apiKey
            ])
        ]
        
        manager = SocketManager(
            socketURL: URL(string: AppConfiguration.baseURL)!,
            config: config
        )
        
        // 특정 방의 네임스페이스에 연결
        socket = manager?.socket(forNamespace: "/chats-\(roomID)")
        
        connectRoomID = roomID
        
        receiveMessageHandler = receiveMessage
        
        setupSocketEvents()
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
        socket = nil
        manager = nil
        receiveMessageHandler = nil
        connectRoomID = nil
    }
    
    func isConnected(roomID: String) -> Bool {
        (connectRoomID == roomID) && (socket?.status == .connected)
    }
}

extension SocketProviderImpl {
    private func setupSocketEvents() {
        // 연결 성공
        socket?.on(clientEvent: .connect) { [weak self] data, ack in
            print("✅ Socket connected to room")
            for value in data {
                guard let v = value as? String,
                      v.hasPrefix("/chats-") else { continue }
                
                let roomID = String(v.dropFirst("/chats-".count))
                self?.connectRoomID = roomID
                print("✅ Socket connected to room: \(data)")
                return
            }
        }
        
        // 연결 실패
        socket?.on(clientEvent: .error) { data, ack in
            print("❌ Socket error: \(data)")
            // TODO: 액세스 토큰 만료에 의한 에러 처리
        }
        
        // 연결 해제
        socket?.on(clientEvent: .disconnect) { [weak self] data, ack in
            print("🔌 Socket disconnected: \(data)")
            self?.connectRoomID = nil
        }
        
        // 새 채팅 메시지 수신
        socket?.on("chat") { [weak self] data, ack in
            guard let self = self else { return }
            self.handleNewMessage(data: data)
        }
    }
    
    private func handleNewMessage(data: [Any]) {
        guard let messageDict = data.first as? [String: Any] else {
            return
        }
        
        do {
            // Dictionary를 JSON Data로 변환
            let jsonData = try JSONSerialization.data(withJSONObject: messageDict)
            
            // JSON Data를 ChatMessageResponseDTO로 디코딩
            let decoder = JSONDecoder()
            let messageDTO = try decoder.decode(ChatMessageResponseDTO.self, from: jsonData)
            
            // DTO를 Domain 모델로 변환
            let chatMessage = messageDTO.toDomain()
            
            receiveMessageHandler?(chatMessage)
            
        } catch {
            print("❌ Failed to decode message: \(error)")
            print("Raw data: \(messageDict)")
        }
    }
}

