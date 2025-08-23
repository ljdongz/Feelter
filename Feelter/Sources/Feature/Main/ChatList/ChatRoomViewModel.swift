//
//  ChatRoomListViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/13/25.
//

import Foundation

import RxCocoa
import RxSwift

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
            .withAsync(with: self, { owner, _ in
                await owner.chatRepository.fetchLocalRooms()
            })
            .subscribe(with: self, onNext: { owner, rooms in
                output.chatRooms.accept(rooms)
                serverFetchTrigger.accept(())
            })
            .disposed(by: disposeBag)
        
        input.receivedAPNs
            .withAsyncResult(with: self) { owner, payload in
                // TODO: 로컬에 저장되지 않은 채팅방ID인 경우(새로운 상대방한테 받은 경우), 전체 채팅방 목록 서버로 가져오는 로직 필요
                try await owner.chatRepository.updateRoom(apnsPayload: payload)
                
                let rooms = await owner.chatRepository.fetchLocalRooms()
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
            .withAsync(with: self) { owner, _ in
                await owner.chatRepository.fetchLocalRooms()
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
