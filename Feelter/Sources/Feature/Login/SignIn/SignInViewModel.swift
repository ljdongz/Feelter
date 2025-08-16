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
    
    typealias SignInResult = (isSuccess: Bool, message: String)
    
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
        let signInResult = PublishRelay<SignInResult>()
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
                switch result {
                case .success:
                    output.signInResult.accept((isSuccess: true, message: ""))
                case .failure(let error):
                    let message = owner.handleError(error)
                    output.signInResult.accept((isSuccess: false, message: message))
                }
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
                    output.signInResult.accept((isSuccess: true, message: ""))
                case .failure(let error):
                    let message = owner.handleError(error)
                    output.signInResult.accept((isSuccess: false, message: message))
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
                    output.signInResult.accept((isSuccess: true, message: ""))
                case .failure(let error):
                    let message = owner.handleError(error)
                    output.signInResult.accept((isSuccess: false, message: message))
                }
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

private extension SignInViewModel {
    func handleError(_ error: Error) -> String {
        switch error {
        case AuthError.alreadyExist:
            return "이미 가입된 유저입니다."
        case HTTPResponseError.invalidObject:
            return "계정을 확인해주세요."
        default:
            return "죄송합니다. 잠시 후 다시 시도해주세요."
        }
    }
}
