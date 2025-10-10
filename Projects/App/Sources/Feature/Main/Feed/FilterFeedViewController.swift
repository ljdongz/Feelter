//
//  FilterFeedViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class FilterFeedViewController: RxBaseViewController {
    
    private let mainView = FilterFeedView()
    
    private let viewModel = FilterFeedViewModel()
    
    private let likeStatusUpdateRelay = PublishRelay<Filter>()

    override func loadView() {
        self.view = mainView
    }
    
    override func setupView() {
        title = "Feed"
        view.backgroundColor = .gray100
    }

    override func bind() {
        
        let input = FilterFeedViewModel.Input(
            viewDidLoad: .just(()),
            categoryButtonTapped: mainView.collectionView.rx
                .itemSelected
                .filter { FilterFeedView.Section(rawValue: $0.section) == .category }
                .compactMap { CategorySectionItem.default[$0.item].category }
                .asObservable()
            ,
            orderButtonTapped: mainView.collectionView.rx
                .itemSelected
                .filter { FilterFeedView.Section(rawValue: $0.section) == .order }
                .compactMap { OrderSectionItem.default[$0.item].order }
                .asObservable(),
            updatedLikeStatus: likeStatusUpdateRelay.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.filters
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, filters in
                owner.mainView.applyFeedSnapShot(filters)
            }
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                switch FilterFeedView.Section(rawValue: indexPath.section) {
                case .category:
                    owner.mainView.updateCategorySelection(selectedIndex: indexPath.item)
                    
                case .order:
                    owner.mainView.updateOrderSelection(selectedIndex: indexPath.item)
                    
                case .topRanking:
                    let filter = owner.viewModel.filters[indexPath.item]
                    let filterDetailViewModel = FilterDetailViewModel(
                        filterID: filter.filterID ?? "",
                        isLiked: filter.isLiked ?? false
                    )
                    
                    let vc = FilterDetailViewController(viewModel: filterDetailViewModel)
                    vc.title = filter.title
                    
                    owner.navigationController?.pushViewController(vc, animated: true)
                    
                case .feed:
                    let filter = owner.viewModel.filters[indexPath.item + 3]
                    let filterDetailViewModel = FilterDetailViewModel(
                        filterID: filter.filterID ?? "",
                        isLiked: filter.isLiked ?? false
                    )
                    
                    let vc = FilterDetailViewController(viewModel: filterDetailViewModel)
                    vc.title = filter.title
                    vc.onChangeLikeStatus = { isLiked in
                        owner.likeStatusUpdateRelay.accept(filter)
                        owner.mainView.updateLikeStatus(filter: filter)
                    }
                    
                    owner.navigationController?.pushViewController(vc, animated: true)
                    
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: FilterFeedViewController())
}
#endif
