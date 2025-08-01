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
            let passwordValidation = ValidationHelper.validateRequired(password, fieldName: "비밀번호")
            
            return emailValidation.isValid && passwordValidation.isValid
        }
        .bind(to: output.isEmailSignInButtonEnabled)
        .disposed(by: disposeBag)
        
        
        // 이메일 로그인 처리
        input.emailSignInButtonTapped
            .withLatestFrom(Observable.combineLatest(input.emailTextField, input.passwordTextField))
            .flatMap { [weak self] email, password in
                guard let self else { return Observable<Void>.empty() }
                
                return Observable<Void>.fromAsync {
                    try await self.authRepository.signInWithEmail(email: email, password: password)
                }
            }
            .subscribe(with: self) { owner, _ in
                print("Email Login Success")
            } onError: { owner, error in
                print("Email Login Error: \(error)")
            }
            .disposed(by: disposeBag)
        
        input.appleSignInButtonTapped
            .flatMap { [weak self] _ in
                guard let self else { return Observable<Void>.empty() }
                
                return Observable<Void>.fromAsync {
                    try await self.authRepository.signInWithApple()
                }
            }
            .subscribe(with: self) { owner, _ in
                print("Apple Login Success")
            } onError: { owner, error in
                print(error)
            }
            .disposed(by: disposeBag)

        input.kakaoSignInButtonTapped
            .flatMap { [weak self] _ in
                guard let self else { return Observable<Void>.empty() }
                
                return Observable<Void>.fromAsync {
                    try await self.authRepository.signInWithKakao()
                }
            }
            .subscribe(with: self) { owner, _ in
                print("Kakao Login Success")
            } onError: { owner, error in
                print(error)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
