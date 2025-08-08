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
            .filter { $0.section == FilterFeedView.Section.category.rawValue }
            .subscribe(onNext: { [weak self] indexPath in
                self?.mainView.updateCategorySelection(selectedIndexPath: indexPath)
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
