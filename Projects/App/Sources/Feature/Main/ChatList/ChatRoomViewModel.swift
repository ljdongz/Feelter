//
//  ChatRoomListViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/13/25.
//

import Foundation

import RxCocoa
import RxSwift

import FTDependencies
import FTStorageInterface

final class ChatRoomViewModel: ViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let receivedAPNs: Observable<APNsPayload>
        let receiveSocketMessage: Observable<Void>
    }
    
    struct Output {
        let chatRooms = BehaviorRelay<[ChatRoom]>(value: [])
    }
    
    @Dependency private var chatRepository: ChatRepository
    @Dependency private var tokenManager: TokenManager

    var disposeBag: DisposeBag = .init()

    var userID: String? {
        tokenManager.userID
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        let serverFetchTrigger = PublishRelay<Void>()
        
        input.viewDidLoad
            .map { [weak self] _ -> [ChatRoom] in
                guard let self else { return [] }
                return self.chatRepository.fetchLocalRooms()
            }
            .subscribe(with: self, onNext: { owner, rooms in
                output.chatRooms.accept(rooms)
                serverFetchTrigger.accept(())
            })
            .disposed(by: disposeBag)
        
        input.receivedAPNs
            .withAsyncResult(with: self) { owner, payload in
                try await owner.chatRepository.updateRoom(apnsPayload: payload)
                
                let rooms = owner.chatRepository.fetchLocalRooms()
                return rooms
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let rooms):
                    output.chatRooms.accept(rooms)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.receiveSocketMessage
            .map { [weak self] _ -> [ChatRoom] in
                guard let self else { return [] }
                return self.chatRepository.fetchLocalRooms()
            }
            .subscribe(with: self) { onwer, rooms in
                output.chatRooms.accept(rooms)
            }
            .disposed(by: disposeBag)
        
        serverFetchTrigger
            .asObservable()
            .withAsyncResult(with: self) { owner, _ in
                try await owner.chatRepository.fetchRooms()
            }
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success(let rooms):
                    output.chatRooms.accept(rooms)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
