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
    
    override func loadView() {
        self.view = mainView
        
        title = "Profile"
    }

    override func bind() {
        let input = MyPageViewModel.Input(
            viewDidLoad: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.myProfile
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, profile in
                owner.mainView.applyDataSource(profile: profile)
            }
            .disposed(by: disposeBag)
        
        mainView.chatRoomButtonTapTrigger
            .subscribe(with: self) { owner, _ in
                let vc = ChatRoomViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
