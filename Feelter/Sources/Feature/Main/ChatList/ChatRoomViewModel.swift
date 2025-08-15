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
    
    var disposeBag: DisposeBag = .init()
    
    @Dependency private var chatRepository: ChatRepository
    
    func transform(input: Input) -> Output {
        let output = Output()
        input.viewDidLoad
            .withAsyncResult(with: self, { owner, _ in
                try await owner.chatRepository.fetchRooms()
            })
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success(let rooms):
                    output.chatRooms.accept(rooms)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
}
