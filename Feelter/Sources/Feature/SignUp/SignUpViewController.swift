//
//  JoinViewController.swift
//  Feelter
//
//  Created by 이정동 on 7/30/25.
//

import UIKit

import RxCocoa
import RxSwift

final class SignUpViewController: RxBaseViewController {
    
    private let mainView = SignUpView()
    
    private let viewModel = SignUpViewModel()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "회원가입"
    }
    
    override func bind() {
        let input = SignUpViewModel.Input(
            emailTextField: mainView.emailTextField.textField.rx
                .text
                .orEmpty
                .distinctUntilChanged()
                .asObservable(),
            validEmailButtonTapped: mainView.emailTextField.trailingButton.rx
                .tap
                .compactMap { [weak self] _ in
                    self?.mainView.emailTextField.textField.text
                }
                .distinctUntilChanged()
                .asObservable(),
            passwordTextField: mainView.passwordTextField.textField.rx
                .text
                .orEmpty
                .distinctUntilChanged()
                .asObservable(),
            nicknameTextField: mainView.nicknameTextField.textField.rx
                .text
                .orEmpty
                .distinctUntilChanged()
                .asObservable(),
            nameTextField: mainView.nameTextField.textField.rx
                .text
                .orEmpty
                .distinctUntilChanged()
                .asObservable(),
            phoneNumberTextField: mainView.phoneTextField.textField.rx
                .text
                .orEmpty
                .distinctUntilChanged()
                .asObservable(),
            introductionTextView: mainView.introduceTextView.textView.rx
                .text
                .orEmpty
                .distinctUntilChanged()
                .asObservable(),
            hashTagAddButtonTapped: mainView.hashTagTextField.trailingButton.rx
                .tap
                .compactMap { [weak self] _ in
                    self?.mainView.hashTagTextField.textField.text
                }
                .do(onNext: { [weak self] _ in self?.mainView.hashTagTextField.textField.text = "" })
                .asObservable(),
            hashTagDeleteButtonTapped: mainView.hashTagCollectionView.rx
                .itemSelected
                .map { $0.item }
                .asObservable(),
            signUpButtonTapped: mainView.signUpButton.rx
                .tap
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isValidEmail
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, result in
                switch result {
                case .valid:
                    owner.mainView.emailTextField.textFieldStatus = .success
                    owner.mainView.emailDescriptLabel.text = "사용 가능한 이메일입니다."
                case .invalid(let message):
                    owner.mainView.emailTextField.textFieldStatus = .fail
                    owner.mainView.emailDescriptLabel.text = message
                case .none:
                    owner.mainView.emailTextField.textFieldStatus = .fail
                    owner.mainView.emailDescriptLabel.text = "이메일 검증이 필요합니다."
                }
            }
            .disposed(by: disposeBag)
        
        output.isValidPassword
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, result in
                switch result {
                case .valid:
                    owner.mainView.passwordTextField.textFieldStatus = .success
                    owner.mainView.passwordDescriptLabel.text = "사용 가능한 패스워드입니다."
                case .invalid(let message):
                    owner.mainView.passwordTextField.textFieldStatus = .fail
                    owner.mainView.passwordDescriptLabel.text = message
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        output.newHashTag
            .filter { !$0.isEmpty }
            .subscribe(with: self) { owner, hashTag in
                owner.mainView.appendHashTag(hashTag)
            }
            .disposed(by: disposeBag)
        
        output.deleteHashTag
            .subscribe(with: self) { owner, hashTag in
                owner.mainView.deleteHashTag(hashTag)
            }
            .disposed(by: disposeBag)
                    
        
        output.isSignUpButtonEnabled
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, isEnabled in
                owner.mainView.isSignUpButtonEnabled = isEnabled
            }
            .disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    SignUpViewController()
}
#endif
