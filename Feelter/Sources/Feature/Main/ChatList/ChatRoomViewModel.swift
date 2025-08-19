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
