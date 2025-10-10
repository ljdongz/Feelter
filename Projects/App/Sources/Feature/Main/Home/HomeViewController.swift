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
                let section = HomeView.Section(rawValue: indexPath.section)!
                
                switch section {
                case .banner:
                    guard let banner = owner.mainView.banner(at: indexPath.item) else {
                        return
                    }
                    
                    owner.presentWebViewController(with: banner.payload.value)
                    
                case .hotTrend:
                    guard let filters = owner.viewModel.homeModel?.hotTrendFilters else { return }
                    let filter = filters[indexPath.item]
                    owner.navigateToFilterDetailViewController(filter: filter) { isLiked in
                        // TODO: 좋아요 상태 업데이트
                    }
                    
                case .authorPhotos:
                    guard let filters = owner.viewModel.homeModel?.todayAuthor.filters else { return }
                    let filter = filters[indexPath.item]
                    owner.navigateToFilterDetailViewController(filter: filter) { isLiked in
                        // TODO: 좋아요 상태 업데이트
                    }
                    
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

    }
}

extension HomeViewController {
    private func presentWebViewController(with path: String) {
        let webViewController = BannerWebViewController(path: path)
        present(webViewController, animated: true)
    }
    
    private func navigateToFilterDetailViewController(
        filter: Filter,
        onChangeLikeStatus: @escaping ((Bool) -> Void)
    ) {
        guard let filterID = filter.filterID,
              let isLiked = filter.isLiked else { return }
        
        let vm = FilterDetailViewModel(filterID: filterID, isLiked: isLiked)
        let vc = FilterDetailViewController(viewModel: vm)
        vc.title = filter.title
        vc.onChangeLikeStatus = onChangeLikeStatus
        navigationController?.pushViewController(vc, animated: true)
    }
}
