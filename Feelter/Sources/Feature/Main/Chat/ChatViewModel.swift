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
    case fullReload([ChatMessage])
    /// 이전 메시지
    case prepend([ChatMessage])
    /// 새 메시지
    case append([ChatMessage])
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
    private let updatedAt: Date
    private let calendar = Calendar.current
    private var lastMessageAt = Date()
    
    var userID: String? {
        tokenManager.userID
    }
    
    var disposeBag: DisposeBag = .init()
    
    init(roomID: String, updatedAt: Date) {
        self.roomID = roomID
        self.updatedAt = updatedAt
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        let serverFetchTrigger = PublishRelay<Void>()
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
                
                output.messages.accept(.fullReload(messages))
                
                serverFetchTrigger.accept(())
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
                    
                    output.messages.accept(.prepend(messages))
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
                    output.messages.accept(.append([message]))
                    
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
            .withAsyncResult(with: self) { owner, _ in
                let utcDate = UTCDateFormatter.shared.string(from: owner.updatedAt)
                return try await owner.chatRepository.fetchMessages(from: owner.roomID, after: utcDate)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let messages):
                    output.messages.accept(.append(messages))
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
            
        return output
    }
}
