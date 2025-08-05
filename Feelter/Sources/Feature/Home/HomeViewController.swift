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

    override func bind() {
        let input = HomeViewModel.Input(
            viewDidLoad: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.todayFilter
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, filter in
                print(filter)
                owner.mainView.applyTodayFilterSnapShot(filter)
            }
            .disposed(by: disposeBag)
        
        output.hotTrendFilters
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, filters in
                print(filters)
                owner.mainView.applyHotTrendFiltersSnapShot(filters)
            }
            .disposed(by: disposeBag)
        
        output.todayAuthor
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, author in
                print(author)
                owner.mainView.applyTodayAuthorSnapShot(author)
            }
            .disposed(by: disposeBag)
    }
}
