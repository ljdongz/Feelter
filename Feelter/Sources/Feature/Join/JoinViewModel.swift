//
//  JoinViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/1/25.
//

import Foundation

import RxCocoa
import RxSwift

final class JoinViewModel: ViewModel {
    struct Input {
        let emailTextField: Observable<String>
        let validEmailButtonTapped: Observable<String>
        
        let passwordTextField: Observable<String>
        
        let nicknameTextField: Observable<String>
    }
    
    struct Output {
        let isValidEmail = PublishRelay<ValidationResult>()
        let isValidPassword = PublishRelay<ValidationResult>()
        
        let isJoinButtonEnable = BehaviorRelay<Bool>(value: false)
    }
    
    @Dependency private var authRepository: AuthRepository
    
    private let emailValidation = BehaviorRelay<Bool>(value: false)
    private let passwordValidation = BehaviorRelay<Bool>(value: false)
    private let nicknameValidation = BehaviorRelay<Bool>(value: false)
    
    var disposeBag: DisposeBag = .init()
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // TODO: 수정하기
        input.emailTextField
            .distinctUntilChanged()
            .subscribe(with: self) { owner, text in
                print("Change")
                owner.emailValidation.accept(false)
                
                output.isValidEmail.accept(.none)
            }
            .disposed(by: disposeBag)
        
        // TODO: 검사 상태에 따른 이벤트 전달 로직 수정 (with 에러처리)
        input.validEmailButtonTapped
            .flatMap { [weak self] email -> Observable<ValidationResult> in
                guard let self else { return .empty() }
                
                return .fromAsync {
                    try await self.authRepository.validationEmail(email: email)
                    return ValidationResult.valid
                }
                .catch { error in
                    return .just(.invalid(message: "사용할 수 없는 이메일입니다."))
                }
            }
            .subscribe(with: self) { owner, result in
                owner.emailValidation.accept(result.isValid)
                output.isValidEmail.accept(result)
            }
            .disposed(by: disposeBag)

        input.passwordTextField
            .subscribe(with: self) { owner, password in
                let result = ValidationHelper.validatePassword(password)
                
                owner.passwordValidation.accept(result.isValid)
                output.isValidPassword.accept(result)
            }
            .disposed(by: disposeBag)
        
        input.nicknameTextField
            .subscribe(with: self) { owner, nickname in
                let isEmpty = nickname.trimmingCharacters(in: .whitespaces).isEmpty
                owner.nicknameValidation.accept(!isEmpty)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            emailValidation,
            passwordValidation,
            nicknameValidation
        ) {
            $0 && $1 && $2
        }
        .bind(to: output.isJoinButtonEnable)
        .disposed(by: disposeBag)
            
        
        return output
    }
}
