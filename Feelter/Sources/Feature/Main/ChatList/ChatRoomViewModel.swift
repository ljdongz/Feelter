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
        
        let trigger = PublishRelay<Void>()
        
        input.viewDidLoad
            .withAsyncResult(with: self, { owner, _ in
                try await owner.chatRepository.fetchLocalRooms()
            })
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success(let rooms):
                    print("Fetch Local Success")
                    output.chatRooms.accept(rooms)
                    trigger.accept(())
                case .failure(let error):
                    print("Fetch Local Error")
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        trigger
            .asObservable()
            .withAsyncResult(with: self) { owner, _ in
                try await owner.chatRepository.fetchRooms()
            }
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success(let rooms):
                    print("Fetch Server Success")
                    output.chatRooms.accept(rooms)
                case .failure(let error):
                    print("Fetch Server Error")
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
}
