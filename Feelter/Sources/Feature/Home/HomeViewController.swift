//
//  HomeViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/5/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class HomeViewController: RxBaseViewController {
    
    private let mainView = HomeView()

    private let viewModel = HomeViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray100
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
        let input = HomeViewModel.Input(
            viewDidLoad: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
//        output.todayFilter
//            .observe(on: MainScheduler.instance)
//            .subscribe(with: self) { owner, filter in
//                owner.mainView.applyTodayFilterSnapShot(filter)
//            }
//            .disposed(by: disposeBag)
//        
//        
//        
//        output.hotTrendFilters
//            .observe(on: MainScheduler.instance)
//            .subscribe(with: self) { owner, filters in
//                owner.mainView.applyHotTrendFiltersSnapShot(filters)
//            }
//            .disposed(by: disposeBag)
//        
//        output.todayAuthor
//            .observe(on: MainScheduler.instance)
//            .subscribe(with: self) { owner, todayAuthor in
//                owner.mainView.applyTodayAuthorSnapShot(todayAuthor)
//            }
//            .disposed(by: disposeBag)
        output.homeModel
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, data in
                owner.mainView.applyTodayFilterSnapShot(data.todayFilter)
                owner.mainView.applyBannerSnapShot(data.banners)
                owner.mainView.applyHotTrendFiltersSnapShot(data.hotTrendFilters)
                owner.mainView.applyTodayAuthorSnapShot(data.todayAuthor)
            }
            .disposed(by: disposeBag)
    }
}
