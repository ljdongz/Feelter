//
//  ViewController.swift
//  Feelter
//
//  Created by 이정동 on 7/21/25.
//

import SwiftUI
import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class SignInViewController: RxBaseViewController {
    
    private let mainView: SignInView = {
        let view = SignInView()
        return view
    }()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
    }
    
    
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
    SignInViewController()
}
#endif
