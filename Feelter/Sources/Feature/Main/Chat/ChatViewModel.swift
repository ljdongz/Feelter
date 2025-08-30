//
//  ChatRoomViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/15/25.
//

import Foundation

import RxCocoa
import RxSwift

enum UpdateType {
    /// 초기 로드, 재연결
    case initMessages([ChatMessage])
    /// 이전 메시지
    case prependPastMessages([ChatMessage])
    /// 읽지 않은 새 메시지
    case appendUnReadMessages([ChatMessage])
    /// 새 메시지
    case appendNewMessage(ChatMessage)
}

final class ChatViewModel: ViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let viewWillDisappear: Observable<Void>
        let sendMessageButtonTapped: Observable<String>
        let loadMoreMessages: Observable<Void>
    }
    
    struct Output {
        let messages = PublishRelay<UpdateType>()
    }
    
    @Dependency private var chatRepository: ChatRepository
    @Dependency private var tokenManager: TokenManager
    
    private let roomID: String
    private let calendar = Calendar.current
    private var lastMessageAt = Date() // 과거 메시지 데이터를 불러오기 위한 기준 날짜
    
    var userID: String? {
        tokenManager.userID
    }
    
    var disposeBag: DisposeBag = .init()
    
    init(roomID: String) {
        self.roomID = roomID
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        let serverFetchTrigger = PublishRelay<Date>()
        let receiveMessageTrigger = PublishRelay<ChatMessage>()
        
        input.viewDidLoad
            .do(onNext: { [weak self] _ in
                guard let self else { return }
                chatRepository.connectRoom(roomID: self.roomID) { message in
                    receiveMessageTrigger.accept(message)
                }
            })
            .withAsync(with: self) { owner, _ in
                await owner.chatRepository.fetchLocalMessages(
                    from: owner.roomID,
                    before: owner.lastMessageAt
                )
            }
            .subscribe(with: self) { owner, messages in
                owner.lastMessageAt = messages.first?.createdAt ?? .distantPast
                
                output.messages.accept(.initMessages(messages))
                
                serverFetchTrigger.accept(messages.last?.createdAt ?? Date())
            }
            .disposed(by: disposeBag)
        
        input.viewWillDisappear
            .subscribe(with: self) { owner, _ in
                owner.chatRepository.disconnectRoom()
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
                    // TODO: 로컬에 메시지 저장 (전송중)
                    print("보내기 성공")
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.loadMoreMessages
            .withAsyncResult(with: self) { owner, _ in
                await owner.chatRepository.fetchLocalMessages(
                    from: owner.roomID,
                    before: owner.lastMessageAt
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let messages):
                    owner.lastMessageAt = messages.first?.createdAt ?? .distantPast
                    
                    output.messages.accept(.prependPastMessages(messages))
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        receiveMessageTrigger.asObservable()
            .withAsyncResult(with: self) { owner, message in
                try await owner.chatRepository.saveMessage(message)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let message):
                    output.messages.accept(.appendNewMessage(message))
                    
                    NotificationCenter.default.post(
                        name: .ReceiveSocketMessage,
                        object: nil
                    )
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        serverFetchTrigger.asObservable()
            .withAsyncResult(with: self) { owner, date in
                let utcDate = UTCDateFormatter.shared.string(from: date)
                return try await owner.chatRepository.fetchMessages(from: owner.roomID, after: utcDate)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let messages):
                    output.messages.accept(.appendUnReadMessages(messages))
                    
                    NotificationCenter.default.post(
                        name: .ReceiveSocketMessage,
                        object: nil
                    )
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
            
        return output
    }
}
