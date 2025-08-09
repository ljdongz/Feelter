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
    
    private let viewModel = FilterDetailViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func bind() {
        let input = FilterDetailViewModel.Input()
        
        let output = viewModel.transform(input: input)
    }
}
