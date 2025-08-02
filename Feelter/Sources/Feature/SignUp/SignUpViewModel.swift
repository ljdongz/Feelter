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
            .flatMap { [weak self] () -> Observable<Void> in
                guard let self else { return .empty() }
                return .fromAsync {
                    try await self.authRepository.signUpWithEmail(self.signUpForm)
                }
                .catch { error in
                    print(error)
                    return .empty()
                }
            }
            .subscribe(with: self) { owner, _ in
                print("SignUp Success")
                output.isLoadingSignUp.accept(false)
            } onError: { owner, error in
                print("SignUp Error: \(error)")
                output.isLoadingSignUp.accept(false)
            }
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
