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

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray100
        // Do any additional setup after loading the view.
    }

}
