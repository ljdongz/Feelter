//
//  ChatRoomViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/15/25.
//

import Foundation

import RxCocoa
import RxSwift

final class ChatViewModel: ViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let sendMessageButtonTapped: Observable<String>
    }
    
    struct Output {
        let messages = PublishRelay<UpdateType>()
    }
    
    @Dependency private var chatRepository: ChatRepository
    @Dependency private var tokenManager: TokenManager
    
    private let roomID: String
    private let calendar = Calendar.current
    
    var disposeBag: DisposeBag = .init()
    
    init(roomID: String) {
        self.roomID = roomID
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .withAsyncResult(with: self) { owner, _ in
                try await owner.chatRepository.fetchMessages(from: owner.roomID, after: nil)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let messages):
                    let cellTypes = owner.convertToCellTypes(messages: messages)
                    output.messages.accept(.fullReload(cellTypes))
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.sendMessageButtonTapped
            .withAsyncResult(with: self) { owner, message in
                try await owner.chatRepository.sendMessage(
                    to: owner.roomID,
                    message: .init(
                        content: message,
                        fileURLs: []
                    ))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let message):
                    // TODO: 연속 프로필 처리 필요
                    let cellType = owner.convertToSingleCellType(message: message)
                    output.messages.accept(.append(cellType))
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

// MARK: - MessageCellType Method

extension ChatViewModel {
    
    private func convertToCellTypes(messages: [ChatMessage]) -> [MessageCellType] {
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
                didAddDateSeparator: isDateSeparator
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
                showTime: showTime
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
        didAddDateSeparator: Bool
    ) -> Bool {
        // 내 메시지는 항상 프로필 숨김
        guard currentMessage.sender.userID != tokenManager.userID else { return false }
        
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
        showTime: Bool = true
    ) -> MessageCellType {
        let isMe = message.sender.userID == tokenManager.userID
        
        let sender = MessageItem.MessageSender(
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

// MARK: - Model

enum UpdateType {
    /// 초기 로드, 재연결
    case fullReload([MessageCellType])
    /// 이전 메시지
    case prepend([MessageCellType])
    /// 새 메시지
    case append(MessageCellType)
}

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
        let name: String
        let profileImageURL: String?
        let isMe: Bool
    }
}
