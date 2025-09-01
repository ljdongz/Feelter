//
//  MyPageViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/22/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class MyPageViewController: RxBaseViewController {

    private let mainView = MyPageView()
    
    private let viewModel = MyPageViewModel()
    
    private let signOutTrigger = PublishRelay<Void>()
    private let withdrawalTrigger = PublishRelay<Void>()
    
    override func loadView() {
        self.view = mainView
        
        title = "Profile"
    }

    override func bind() {
        let input = MyPageViewModel.Input(
            viewDidLoad: .just(()),
            signOutButtonTapped: signOutTrigger.asObservable(),
            withdrawButtonTapped: withdrawalTrigger.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.myProfile
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, profile in
                owner.mainView.applyDataSource(profile: profile)
            }
            .disposed(by: disposeBag)
        
        output.navigateToSignIn
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                RootViewSwitcher.shared.changeRootView(to: .signIn)
            }
            .disposed(by: disposeBag)
        
        output.responseError
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, message in
                let alertVC = UIAlertController(
                    title: "에러가 발생했습니다.",
                    message: message,
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "확인", style: .cancel)
                alertVC.addAction(okAction)
                owner.present(alertVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.chatRoomButtonTapTrigger
            .subscribe(with: self) { owner, _ in
                let vc = ChatRoomViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                switch MyPageView.Section(rawValue: indexPath.section)! {
                case .signOut:
                    let alertVC = UIAlertController(
                        title: "로그아웃 하시겠습니까?",
                        message: nil,
                        preferredStyle: .alert
                    )
                    let okAction = UIAlertAction(
                        title: "로그아웃",
                        style: .destructive
                    ) { _ in
                        owner.signOutTrigger.accept(())
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    alertVC.addAction(okAction)
                    alertVC.addAction(cancelAction)
                    owner.present(alertVC, animated: true)
                case .withdrawal:
                    let alertVC = UIAlertController(
                        title: "회원탈퇴 하시겠습니까?",
                        message: "회원탈퇴 시 기존 데이터는 모두 삭제됩니다.",
                        preferredStyle: .alert
                    )
                    let okAction = UIAlertAction(
                        title: "회원탈퇴",
                        style: .destructive
                    ) { _ in
                        owner.withdrawalTrigger.accept(())
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    alertVC.addAction(okAction)
                    alertVC.addAction(cancelAction)
                    owner.present(alertVC, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
