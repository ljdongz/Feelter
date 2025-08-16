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
                    print(error.localizedDescription)
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

// MARK: - Convert to MessageCellType Method

extension ChatViewModel {
    
    private func convertToCellTypes(messages: [ChatMessage]) -> [MessageCellType] {
        var cellTypes: [MessageCellType] = []
        var lastDate: Date?
        
        for message in messages {
            let messageDate = message.createdAt
            
            // 새로운 날짜인 경우 구분선 추가
            if shouldAddDateSeparator(lastDate: lastDate, currentDate: messageDate) {
                cellTypes.append(.dateSeparator(messageDate))
                lastDate = messageDate
            }
            
            // 메시지 추가
            cellTypes.append(convertToSingleCellType(message: message))
        }
        
        return cellTypes
    }
    
    private func shouldAddDateSeparator(lastDate: Date?, currentDate: Date) -> Bool {
        guard let lastDate = lastDate else { return true }
        return !Calendar.current.isDate(lastDate, inSameDayAs: currentDate)
    }
    
    private func convertToSingleCellType(message: ChatMessage) -> MessageCellType {
        let isMe = message.sender.userID == tokenManager.userID
        
        let sender = MessageItem.MessageSender(
            name: message.sender.nickname,
            profileImageURL: message.sender.profileImageURL,
            isMe: isMe
        )
        
        return .message(MessageItem(
            sender: sender,
            content: message.content,
            timestamp: message.createdAt
        ))
    }
}

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
    
    struct MessageSender: Hashable {
        let name: String
        let profileImageURL: String?
        let isMe: Bool
    }
}
