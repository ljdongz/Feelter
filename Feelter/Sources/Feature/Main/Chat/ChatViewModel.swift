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
                    output.messages.accept(.fullReload(messages))
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
                    print(message)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

extension ChatViewModel {
    enum UpdateType {
        /// 초기 로드, 재연결
        case fullReload([ChatMessage])
        /// 이전 메시지
        case prepend([ChatMessage])
        /// 새 메시지
        case append(ChatMessage)
    }
}
