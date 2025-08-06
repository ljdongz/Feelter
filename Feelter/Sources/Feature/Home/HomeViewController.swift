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
        
        output.homeModel
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, data in
                owner.mainView.applyTodayFilterSnapShot(data.todayFilter)
                owner.mainView.applyBannerSnapShot(data.banners)
                owner.mainView.applyHotTrendFiltersSnapShot(data.hotTrendFilters)
                owner.mainView.applyTodayAuthorSnapShot(data.todayAuthor)
            }
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                let section = HomeView.Section(rawValue: indexPath.section)
                
                switch section {
                case .banner:
                    let banner = owner.mainView.getBanner(item: indexPath.item)
                    let url = AppConfiguration.baseURL + banner.payload.value
                    owner.presentWebViewController(with: url)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

    }
}

// MARK: - WebView

private extension HomeViewController {
    func presentWebViewController(with urlString: String) {
        let webViewController = WebViewController(urlString: urlString)
        present(webViewController, animated: true)
    }
}
