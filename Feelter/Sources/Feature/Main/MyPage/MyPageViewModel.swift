//
//  MyPageViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/22/25.
//

import Foundation

import RxCocoa
import RxSwift

final class MyPageViewModel: ViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let myProfile = PublishRelay<Profile>()
    }
    
    @Dependency private var userRepository: UserRepository
    
    var disposeBag: DisposeBag = .init()
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .withAsyncResult(with: self) { owner, _ in
                try await owner.userRepository.fetchMyProfile()
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let profile):
                    output.myProfile.accept(profile)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
