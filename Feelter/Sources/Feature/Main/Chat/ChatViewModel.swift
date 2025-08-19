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
    case append(ChatMessage)
}

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
    
    private let receiveMessageTrigger = PublishRelay<ChatMessage>()
    
    private let roomID: String
    private let calendar = Calendar.current
    
    var userID: String? {
        tokenManager.userID
    }
    
    var disposeBag: DisposeBag = .init()
    
    init(roomID: String) {
        self.roomID = roomID
    }
    
    deinit {
        chatRepository.disconnectRoom()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .do(onNext: { [weak self] _ in
                guard let self else { return }
                chatRepository.connectRoom(roomID: self.roomID) { message in
                    self.receiveMessageTrigger.accept(message)
                }
            })
            .withAsyncResult(with: self) { owner, _ in
                try await owner.chatRepository.fetchMessages(from: owner.roomID, after: nil)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let messages):
                    output.messages.accept(.fullReload(messages))
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
                    print("보내기 성공")
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
                    output.messages.accept(.append(message))
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
