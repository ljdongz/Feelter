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
    }
    
    struct Output {
        let isValidEmail = PublishRelay<ValidationResult>()
        let isValidPassword = PublishRelay<ValidationResult>()
    }
    
    @Dependency private var authRepository: AuthRepository
    
    var disposeBag: DisposeBag = .init()
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // TODO: 수정하기
        input.emailTextField
            .subscribe(with: self) { owner, text in
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
                output.isValidEmail.accept(result)
            }
            .disposed(by: disposeBag)

        input.passwordTextField
            .subscribe(with: self) { owner, password in
                let isValid = ValidationHelper.validatePassword(password)
                output.isValidPassword.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
