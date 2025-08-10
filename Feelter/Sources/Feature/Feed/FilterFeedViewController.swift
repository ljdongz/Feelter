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
                .asObservable()
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
                    let selectedFilter = owner.viewModel.filters[indexPath.item]
                    owner.navigateToDetail(with: selectedFilter)
                    
                case .feed:
                    let selectedFilter = owner.viewModel.filters[indexPath.item + 3]
                    owner.navigateToDetail(with: selectedFilter)
                    
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

private extension FilterFeedViewController {
    func navigateToDetail(with item: Filter) {
        let filterDetailViewModel = FilterDetailViewModel(
            filterID: item.filterID ?? "",
            isLiked: item.isLiked ?? false
        )
        
        let vc = FilterDetailViewController(viewModel: filterDetailViewModel)
        vc.title = item.title
        navigationController?.pushViewController(vc, animated: true)
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: FilterFeedViewController())
}
#endif
