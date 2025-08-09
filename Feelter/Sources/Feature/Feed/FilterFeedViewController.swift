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
        mainView.collectionView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                switch FilterFeedView.Section(rawValue: indexPath.section) {
                case .category:
                    owner.mainView.updateCategorySelection(selectedIndex: indexPath.item)
                case .order:
                    owner.mainView.updateOrderSelection(selectedIndex: indexPath.item)
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
