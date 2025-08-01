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
        let nameTextField: Observable<String>
        let phoneNumberTextField: Observable<String>
        let introductionTextView: Observable<String>
        
        let hashTagAddButtonTapped: Observable<String>
        let hashTagDeleteButtonTapped: Observable<Int>
    }
    
    struct Output {
        let isValidEmail = PublishRelay<ValidationResult>()
        let isValidPassword = PublishRelay<ValidationResult>()
        
        let hashTags = BehaviorRelay<[String]>(value: [])
        
        let isJoinButtonEnable = BehaviorRelay<Bool>(value: false)
    }
    
    @Dependency private var authRepository: AuthRepository
    
    private var joinInputField = JoinInputField()
    
    private let emailValidation = BehaviorRelay<Bool>(value: false)
    private let passwordValidation = BehaviorRelay<Bool>(value: false)
    private let nicknameValidation = BehaviorRelay<Bool>(value: false)
    
    var disposeBag: DisposeBag = .init()
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // TODO: 수정하기
        input.emailTextField
            .subscribe(with: self) { owner, email in
                owner.joinInputField.email = email
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
                owner.joinInputField.password = password
                
                output.isValidPassword.accept(result)
            }
            .disposed(by: disposeBag)
        
        input.nicknameTextField
            .subscribe(with: self) { owner, nickname in
                let isEmpty = nickname.trimmingCharacters(in: .whitespaces).isEmpty
                owner.nicknameValidation.accept(!isEmpty)
                owner.joinInputField.nickname = nickname
            }
            .disposed(by: disposeBag)
        
        input.nameTextField
            .subscribe(with: self) { owner, name in
                owner.joinInputField.name = name
            }
            .disposed(by: disposeBag)
        
        input.hashTagAddButtonTapped
            .subscribe(with: self) { owner, hashTag in
                owner.joinInputField.hashTags.append(hashTag)
                output.hashTags.accept(owner.joinInputField.hashTags)
            }
            .disposed(by: disposeBag)
        
        input.hashTagDeleteButtonTapped
            .subscribe(with: self) { owner, index in
                print("Delete")
                owner.joinInputField.hashTags.remove(at: index)
                output.hashTags.accept(owner.joinInputField.hashTags)
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

extension JoinViewModel {
    struct JoinInputField {
        var email: String = ""
        var password: String = ""
        var nickname: String = ""
        var name: String?
        var phoneNumber: String?
        var introduction: String?
        var hashTags: [String] = []
    }
}
