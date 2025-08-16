//
//  JoinViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/1/25.
//

import Foundation

import RxCocoa
import RxSwift

final class SignUpViewModel: ViewModel {
    
    typealias SignUpResult = (isSuccess: Bool, message: String)
    
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
        let signUpButtonTapped: Observable<Void>
    }
    
    struct Output {
        let isValidEmail = PublishRelay<ValidationResult>()
        let isValidPassword = PublishRelay<ValidationResult>()
        let newHashTag = PublishRelay<String>()
        let deleteHashTag = PublishRelay<String>()
        let isSignUpButtonEnabled = BehaviorRelay<Bool>(value: false)
        let isLoadingSignUp = PublishRelay<Bool>()
        let signUpResult = PublishRelay<SignUpResult>()
    }
    
    @Dependency private var authRepository: AuthRepository
    
    private var signUpForm = SignUpForm()
    
    private let emailValidation = BehaviorRelay<Bool>(value: false)
    private let passwordValidation = BehaviorRelay<Bool>(value: false)
    private let nicknameValidation = BehaviorRelay<Bool>(value: false)
    
    var disposeBag: DisposeBag = .init()
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // 이메일 입력 필드
        input.emailTextField
            .subscribe(with: self) { owner, email in
                owner.signUpForm.email = email
                owner.emailValidation.accept(false)
                
                output.isValidEmail.accept(.invalid(message: "이메일 검증이 필요합니다."))
            }
            .disposed(by: disposeBag)
        
        // 이메일 검증 버튼 클릭
        input.validEmailButtonTapped
            .map { email in
                let validation = ValidationHelper.validateEmail(email)
                return (email, validation)
            }
            .flatMap { email, validation in
                if validation.isValid {
                    return Observable.just(email)
                        .withAsyncResult(with: self, { owner, email in
                            try await owner.authRepository.validationEmail(email: email)
                        })
                } else {
                    return Observable.just(.failure(ValidationError.invalidFormat))
                }
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    owner.emailValidation.accept(true)

                    output.isValidEmail.accept(.valid)
                case .failure(let error):
                    let message = owner.handleError(error)
                    owner.emailValidation.accept(false)

                    output.isValidEmail.accept(.invalid(message: message))
                }
            }
            .disposed(by: disposeBag)

        // 비밀번호 입력 필드
        input.passwordTextField
            .subscribe(with: self) { owner, password in
                let result = ValidationHelper.validatePassword(password)
                
                owner.passwordValidation.accept(result.isValid)
                owner.signUpForm.password = password
                
                output.isValidPassword.accept(result)
            }
            .disposed(by: disposeBag)
        
        // 닉네임 입력 필드
        input.nicknameTextField
            .subscribe(with: self) { owner, nickname in
                let isEmpty = nickname.trimmingCharacters(in: .whitespaces).isEmpty
                owner.nicknameValidation.accept(!isEmpty)
                owner.signUpForm.nickname = nickname
            }
            .disposed(by: disposeBag)
        
        // 이름 입력 필드
        input.nameTextField
            .subscribe(with: self) { owner, name in
                owner.signUpForm.name = name
            }
            .disposed(by: disposeBag)
        
        // 해시태그 추가 버튼 클릭
        input.hashTagAddButtonTapped
            .subscribe(with: self) { owner, hashTag in
                guard !owner.signUpForm.hashTags.contains(hashTag) else { return }
                
                owner.signUpForm.hashTags.append(hashTag)
                
                output.newHashTag.accept(hashTag)
                output.newHashTag.accept("")
            }
            .disposed(by: disposeBag)
        
        // 해시태그 삭제 버튼 클릭
        input.hashTagDeleteButtonTapped
            .subscribe(with: self) { owner, index in
                let hashTag = owner.signUpForm.hashTags[index]
                owner.signUpForm.hashTags.remove(at: index)
                
                output.deleteHashTag.accept(hashTag)
            }
            .disposed(by: disposeBag)
        
        // 회원가입 버튼 클릭
        input.signUpButtonTapped
            .do(onNext: { _ in
                output.isLoadingSignUp.accept(true)
            })
            .withAsyncResult(with: self, { owner, _ in
                try await owner.authRepository.signUpWithEmail(owner.signUpForm)
            })
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success:
                    output.signUpResult.accept((isSuccess: true, message: ""))
                case .failure(let error):
                    let message = owner.handleError(error)
                    owner.emailValidation.accept(false)

                    output.signUpResult.accept((isSuccess: false, message: message))
                }
                
                output.isLoadingSignUp.accept(false)
            })
            .disposed(by: disposeBag)
        
        // 회원가입 버튼 활성화 상태
        Observable.combineLatest(
            emailValidation,
            passwordValidation,
            nicknameValidation
        ) {
            $0 && $1 && $2
        }
        .bind(to: output.isSignUpButtonEnabled)
        .disposed(by: disposeBag)
        
        return output
    }
}

private extension SignUpViewModel {
    func handleError(_ error: Error) -> String {
        switch error {
        case ValidationError.invalidFormat:
            return "이메일 형식이 올바르지 않습니다."
        case AuthError.alreadyExist:
            return "이미 가입된 이메일입니다."
        default:
            return "죄송합니다. 잠시 후 다시 시도해주세요."
        }
    }
}
