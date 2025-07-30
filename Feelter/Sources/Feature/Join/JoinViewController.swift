//
//  JoinViewController.swift
//  Feelter
//
//  Created by 이정동 on 7/30/25.
//

import UIKit

import RxCocoa
import RxSwift

final class JoinViewController: RxBaseViewController {
    
    private let mainView = JoinView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        title = "회원가입"
    }
}
