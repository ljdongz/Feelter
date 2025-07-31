//
//  SignInViewModel.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import RxSwift

final class SignInViewModel: ViewModel {
    struct Input {
        let appleSignInButtonTapped: Observable<Void>
        let kakaoSignInButtonTapped: Observable<Void>
    }
    
    struct Output {
        
    }
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    let disposeBag: DisposeBag = .init()
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
