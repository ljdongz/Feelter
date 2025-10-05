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
        let signOutButtonTapped: Observable<Void>
        let withdrawButtonTapped: Observable<Void>
    }
    
    struct Output {
        let myProfile = PublishRelay<Profile>()
        let navigateToSignIn = PublishRelay<Void>()
        let responseError = PublishRelay<String>()
    }
    
    @Dependency private var userRepository: UserRepository
    @Dependency private var authRepository: AuthRepository
    
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
        
        input.signOutButtonTapped
            .withAsyncResult(with: self) { owner, _ in
                try await owner.authRepository.signOut()
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    output.navigateToSignIn.accept(())
                case .failure(let error):
                    output.responseError.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.withdrawButtonTapped
            .withAsyncResult(with: self) { owner, _ in
                try await owner.authRepository.signOut()
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    output.navigateToSignIn.accept(())
                case .failure(let error):
                    output.responseError.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
