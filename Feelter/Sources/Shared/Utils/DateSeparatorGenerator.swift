//
//  DateSeparatorGenerator.swift
//  Feelter
//
//  Created by Claude on 8/17/25.
//

import Foundation

enum MessageCellType: Hashable {
    case message(MessageItem)
    case dateSeparator(Date)
}

struct MessageItem: Hashable {
    let id = UUID()
    let sender: MessageSender
    let content: String
    let timestamp: Date
    let showProfile: Bool
    let showTime: Bool // 시간 표시 여부
    
    struct MessageSender: Hashable {
        let userID: String
        let name: String
        let profileImageURL: String?
        let isMe: Bool
    }
}

struct DateSeparatorGenerator {
    
    private let calendar = Calendar.current
    
    func generateCellTypes(
        from messages: [ChatMessage],
        currentUserID: String?
    ) -> [MessageCellType] {
        var cellTypes: [MessageCellType] = []
        var lastDate: Date?
        
        for (index, message) in messages.enumerated() {
            let messageDate = message.createdAt
            
            let isDateSeparator = shouldAddDateSeparator(
                lastDate: lastDate,
                currentDate: messageDate
            )
            
            // 새로운 날짜인 경우 구분선 추가
            if isDateSeparator {
                cellTypes.append(.dateSeparator(messageDate))
                lastDate = messageDate
            }
            
            // 프로필 표시 여부 결정
            let showProfile = shouldShowProfile(
                currentMessage: message,
                previousMessage: index > 0 ? messages[index - 1] : nil,
                didAddDateSeparator: isDateSeparator,
                currentUserID: currentUserID
            )
            
            // 시간 표시 여부 결정
            let showTime = shouldShowTime(
                currentMessage: message,
                nextMessage: index < messages.count - 1 ? messages[index + 1] : nil
            )
            
            // 메시지 추가
            cellTypes.append(convertToSingleCellType(
                message: message,
                showProfile: showProfile,
                showTime: showTime,
                currentUserID: currentUserID
            ))
        }
        
        return cellTypes
    }
    
    private func shouldAddDateSeparator(lastDate: Date?, currentDate: Date) -> Bool {
        guard let lastDate = lastDate else { return true }
        return !calendar.isDate(lastDate, inSameDayAs: currentDate)
    }
    
    private func shouldShowProfile(
        currentMessage: ChatMessage,
        previousMessage: ChatMessage?,
        didAddDateSeparator: Bool,
        currentUserID: String?
    ) -> Bool {
        // 내 메시지는 항상 프로필 숨김
        guard currentMessage.sender.userID != currentUserID else { return false }
        
        // 날짜 구분선이 추가되었으면 프로필 표시
        if didAddDateSeparator { return true }
        
        // 이전 메시지가 없으면 프로필 표시
        guard let previousMessage else { return true }
        
        // 이전 메시지와 발신자가 다르면 프로필 표시
        if previousMessage.sender.userID != currentMessage.sender.userID { return true }
        
        // 같은 발신자의 연속 메시지면 프로필 숨김
        return false
    }
    
    private func shouldShowTime(
        currentMessage: ChatMessage,
        nextMessage: ChatMessage?
    ) -> Bool {
        // 다음 메시지가 없으면 시간 표시 (마지막 메시지)
        guard let nextMessage = nextMessage else { return true }
        
        // 다음 메시지와 발신자가 다르면 시간 표시
        if nextMessage.sender.userID != currentMessage.sender.userID { return true }
        
        // 다음 메시지와 시간이 다르면 시간 표시
        if !isSameMinute(currentMessage.createdAt, nextMessage.createdAt) { return true }
        
        // 같은 발신자이고 같은 시간이면 시간 숨김
        return false
    }
    
    private func isSameMinute(_ date1: Date, _ date2: Date) -> Bool {
        let components1 = calendar.dateComponents([.hour, .minute], from: date1)
        let components2 = calendar.dateComponents([.hour, .minute], from: date2)
        
        return components1.hour == components2.hour && components1.minute == components2.minute
    }
    
    private func convertToSingleCellType(
        message: ChatMessage,
        showProfile: Bool = true,
        showTime: Bool = true,
        currentUserID: String?
    ) -> MessageCellType {
        let isMe = message.sender.userID == currentUserID
        
        let sender = MessageItem.MessageSender(
            userID: message.sender.userID,
            name: message.sender.nickname,
            profileImageURL: message.sender.profileImageURL,
            isMe: isMe
        )
        
        return .message(MessageItem(
            sender: sender,
            content: message.content,
            timestamp: message.createdAt,
            showProfile: showProfile,
            showTime: showTime
        ))
    }
}
