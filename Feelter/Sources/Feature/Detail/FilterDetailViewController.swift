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

    private let mainView = FilterDetailView()
    
    private lazy var navigationRightBarButton: UIButton = {
        let view = UIButton()
        view.setImage(.likeEmpty, for: .normal)
        view.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        view.tintColor = .gray15
        view.addTarget(self, action: #selector(rightBarButtonTapped), for: .touchUpInside)
        return view
    }()
    
    private let viewModel = FilterDetailViewModel()
    
    private var isBookmarked = false
    private var rightBarButtonImage: UIImage {
        isBookmarked ? .likeFill : .likeEmpty
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func setupView() {
        view.backgroundColor = .gray100
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navigationRightBarButton)
    }
    
    override func bind() {
        let input = FilterDetailViewModel.Input()
        
        let output = viewModel.transform(input: input)
    }
}

private extension FilterDetailViewController {
    @objc private func rightBarButtonTapped() {
        isBookmarked.toggle()
        navigationRightBarButton.setImage(rightBarButtonImage, for: .normal)
    }
}


#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: FilterDetailViewController())
}
#endif
