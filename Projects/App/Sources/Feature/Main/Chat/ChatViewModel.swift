//
//  ChatRoomViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/15/25.
//

import Foundation

import RxCocoa
import RxSwift

import FTDependencies
import FTStorageInterface
import FTUtility

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
        let sendMessageButtonTapped: Observable<MessageField>
        let loadMoreMessages: Observable<Void>
    }
    
    struct Output {
        let messages = PublishRelay<UpdateType>()
    }
    
    @Dependency private var chatRepository: ChatRepository
    @Dependency private var tokenManager: TokenManager
    
    private let serverFetchTrigger = PublishRelay<Date>()
    private let receiveMessageTrigger = PublishRelay<ChatMessage>()
    
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
        
        input.viewDidLoad
            .do(onNext: { [weak self] _ in
                guard let self else { return }
                chatRepository.connectRoom(roomID: self.roomID) { message in
                    self.receiveMessageTrigger.accept(message)
                }
            })
            .map { [weak self] _ -> [ChatMessage] in
                guard let self else { print("Empty"); return [] }
                return self.chatRepository.fetchLocalMessages(
                    from: self.roomID,
                    before: self.lastMessageAt
                )
            }
            .subscribe(with: self) { owner, messages in
                owner.lastMessageAt = messages.first?.createdAt ?? .distantPast
                output.messages.accept(.initMessages(messages))
                owner.serverFetchTrigger.accept(messages.last?.createdAt ?? Date())
            }
            .disposed(by: disposeBag)
        
        input.viewWillDisappear
            .subscribe(with: self) { owner, _ in
                owner.chatRepository.disconnectRoom()
            }
            .disposed(by: disposeBag)
        
        input.sendMessageButtonTapped
            .withAsyncResult(with: self) { owner, message in
                // TODO: 수정
                let files = message.files.compactMap { (imageData: ImageData) -> FileData? in
                    if imageData.extension == .png,
                       let data = imageData.image.pngData(),
                       data.count <= 1024 * 1024 {
                        return FileData(data: data, extension: .png)
                    } else {
                        guard let data = imageData.image.jpegData() else { return nil }
                        return FileData(data: data, extension: .jpeg)
                    }
                }

                var urls: [String] = []
                if !files.isEmpty {
                    urls = try await owner.chatRepository.uploadFiles(roomID: owner.roomID, files: files)
                }
                
                return try await owner.chatRepository.sendMessage(
                    to: owner.roomID,
                    message: .init(
                        content: message.content,
                        fileURLs: urls
                    ))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let message):
                    // TODO: 로컬에 메시지 저장 (전송중)
                    print("보내기 성공: \(message)")
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.loadMoreMessages
            .map { [weak self] _ -> [ChatMessage] in
                guard let self else { return [] }
                return self.chatRepository.fetchLocalMessages(
                    from: self.roomID,
                    before: self.lastMessageAt
                )
            }
            .subscribe(with: self) { owner, messages in
                owner.lastMessageAt = messages.first?.createdAt ?? .distantPast
                
                output.messages.accept(.prependPastMessages(messages))
            }
            .disposed(by: disposeBag)
        
        receiveMessageTrigger.asObservable()
            .flatMap { [weak self] message -> Observable<ChatMessage> in
                guard let self else { return .empty() }
                do {
                    let saved = try self.chatRepository.saveMessage(message)
                    return .just(saved)
                } catch {
                    print(error)
                    return .empty()
                }
            }
            .subscribe(with: self) { owner, message in
                output.messages.accept(.appendNewMessage(message))

                NotificationCenter.default.post(
                    name: .ReceiveSocketMessage,
                    object: nil
                )
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
