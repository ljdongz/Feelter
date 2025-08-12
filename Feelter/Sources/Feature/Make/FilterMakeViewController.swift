//
//  FilterMakeViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/11/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class FilterMakeViewController: RxBaseViewController {

    private let mainView = FilterMakeView()
    
    private let viewModel = FilterMakeViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func setupView() {
        title = "Make"
    }
    
    override func bind() {
        
    }
}
