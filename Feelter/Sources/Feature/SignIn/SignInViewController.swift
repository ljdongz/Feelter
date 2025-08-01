//
//  ViewController.swift
//  Feelter
//
//  Created by 이정동 on 7/21/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class SignInViewController: RxBaseViewController {
    
    private let mainView: SignInView = {
        let view = SignInView()
        return view
    }()
    
    private let viewModel = SignInViewModel()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func bind() {
        
        let input = SignInViewModel.Input(
            emailTextField: mainView.emailTextField.textField.rx.text.orEmpty.asObservable(),
            passwordTextField: mainView.passwordTextField.textField.rx.text.orEmpty.asObservable(),
            emailSignInButtonTapped: mainView.signInButton.rx.tap.asObservable(),
            appleSignInButtonTapped: mainView.appleSignInButton.rx.tap.asObservable(),
            kakaoSignInButtonTapped: mainView.kakaoSignInButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isEmailSignInButtonEnabled
            .distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, isEnable in
                owner.mainView.isSignInButtonEnable = isEnable
            })
            .disposed(by: disposeBag)
        
        mainView.joinButton.rx.tap
            .subscribe { _ in
                let vc = JoinViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: SignInViewController())
}
#endif
