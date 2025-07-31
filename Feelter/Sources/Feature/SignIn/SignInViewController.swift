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
    
    override func loadView() {
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
