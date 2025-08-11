//
//  FilterDetailViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/9/25.
//

import UIKit

import RxCocoa
import RxSwift

final class FilterDetailViewController: RxBaseViewController {
    
    private lazy var navigationRightBarButton: UIButton = {
        let view = UIButton()
        view.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        view.tintColor = .gray15
        return view
    }()
    
    private let mainView = FilterDetailView()
    
    private let viewModel: FilterDetailViewModel
    
    var onChangeLikeStatus: ((Bool) -> Void)?
    
    init(viewModel: FilterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func setupView() {
        view.backgroundColor = .gray100
                
        navigationRightBarButton.setImage(
            viewModel.isLiked ? .likeFill : .likeEmpty,
            for: .normal
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navigationRightBarButton)
    }
    
    override func bind() {
        let input = FilterDetailViewModel.Input(
            viewDidLoad: .just(()),
            likekButtonTapped: navigationRightBarButton.rx
                .tap
                .asObservable()
        )

        let output = viewModel.transform(input: input)
        
        output.filterDetail
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, filterDetail in
                owner.mainView.applySnapShot(filter: filterDetail)
            }
            .disposed(by: disposeBag)
        
        output.updatedLikeStatus
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, isLiked in
                owner.onChangeLikeStatus?(isLiked)
                
                owner.navigationRightBarButton.setImage(
                    isLiked ? .likeFill : .likeEmpty,
                    for: .normal
                )
            }
            .disposed(by: disposeBag)
    }
}


#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(
        rootViewController: FilterDetailViewController(
            viewModel: FilterDetailViewModel(filterID: "", isLiked: false)
        )
    )
}
#endif
