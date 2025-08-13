//
//  ChatRoomListViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/13/25.
//

import Foundation

import RxCocoa
import RxSwift

final class ChatRoomListViewModel: ViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let chatRooms = BehaviorRelay<[ChatRoomListCellItem]>(value: [])
    }
    
    var disposeBag: DisposeBag = .init()
    
    func transform(input: Input) -> Output {
        let output = Output()
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                output.chatRooms.accept([
                    .init(profileImageURL: "", name: "윤새싹12", message: "안녕하세요\n반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요", date: "오후 1:15", unreadCount: 100),
                    .init(profileImageURL: "", name: "윤새싹123", message: "안녕하세요\n반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요반가워요", date: "오후 1:15", unreadCount: 950),
                    .init(profileImageURL: "", name: "윤새싹1332", message: "안녕하반가워요반가워요", date: "오후 1:15", unreadCount: 10),
                    .init(profileImageURL: "", name: "윤새싹12342", message: "안녕하세요\n반가워요반가워요", date: "오후 1:15", unreadCount: 999),
                    .init(profileImageURL: "", name: "윤새싹14322", message: "안녕하가워요", date: "오후 1:15", unreadCount: 0)
                ])
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
}
