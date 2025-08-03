//
//  SignInViewModel.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

import RxCocoa
import RxSwift

final class SignInViewModel: ViewModel {
    
    struct Input {
        let emailTextField: Observable<String>
        let passwordTextField: Observable<String>
        let emailSignInButtonTapped: Observable<Void>
        let appleSignInButtonTapped: Observable<Void>
        let kakaoSignInButtonTapped: Observable<Void>
    }
    
    struct Output {
        let isEmailSignInButtonEnabled = BehaviorRelay<Bool>(value: false)
        let isLoadingEmailSignIn = PublishRelay<Bool>()
    }
    
    @Dependency private var authRepository: AuthRepository
    
    let disposeBag: DisposeBag = .init()
    
    func transform(input: Input) -> Output {
        
        let output = Output()
        
        // 로그인 버튼 활성화 상태
        Observable.combineLatest(
            input.emailTextField,
            input.passwordTextField
        ) { email, password in
            let emailValidation = ValidationHelper.validateEmail(email)
            let isPasswordValid = password.count >= 8
            
            return emailValidation.isValid && isPasswordValid
        }
        .bind(to: output.isEmailSignInButtonEnabled)
        .disposed(by: disposeBag)
        
        
        // 이메일 로그인
        input.emailSignInButtonTapped
            .do(onNext: { _ in
                output.isLoadingEmailSignIn.accept(true)
            })
            .withLatestFrom(Observable.combineLatest(
                input.emailTextField,
                input.passwordTextField
            ))
            .withAsyncResult(with: self, { owner, value in
                let (email, password) = value
                try await owner.authRepository.signInWithEmail(email: email, password: password)
            })
            .subscribe(with: self) { owner, result in
                print("Email Login :\(result)")
                output.isLoadingEmailSignIn.accept(false)
            }
            .disposed(by: disposeBag)
        
        // 애플 로그인
        input.appleSignInButtonTapped
            .withAsyncResult(with: self, { owner, _ in
                try await owner.authRepository.signInWithApple()
            })
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    print("Apple Login Success")
                case .failure(let error):
                    print("Apple Login Failed : \(error)")
                }
            }
            .disposed(by: disposeBag)

        // 카카오 로그인
        input.kakaoSignInButtonTapped
            .withAsyncResult(with: self, { owner, _ in
                try await owner.authRepository.signInWithKakao()
            })
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    print("Kakao Login Success")
                case .failure(let error):
                    print("Kakao Login Failed : \(error)")
                }
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
