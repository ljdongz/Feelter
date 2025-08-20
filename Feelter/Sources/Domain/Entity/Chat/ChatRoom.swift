//
//  ChatRoom.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

struct ChatRoom: Hashable {
    let roomID: String
    let participants: [MessageSender]
    
    let lastMessage: String
    let isLastMessageFile: Bool
    
    let createdAt: Date
    /// 서버 기준으로 채팅방이 업데이트 된 날짜 (새 메시지를 수신한 날짜)
    let updatedAt: Date
    /// 클라이언트 기준으로 채팅방이 업데이트 된 날짜 (새 메시지를 수신한 날짜)
    /// -> 푸시 알림으로 메시시 수신을 감지한 경우 업데이트 됨
    /// updatedAt <= localUpdatedAt 구조를 가짐
    let localUpdatedAt: Date
}

