//
//  ViewController.swift
//  Feelter
//
//  Created by 이정동 on 7/21/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class ViewController: RxBaseViewController {
    
    private lazy var image: UITextField = {
        let view = UITextField()
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(image)
        image.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
        }
    }

    override func addSubviews() {
        
    }
    
    override func configureConstraints() {
        
    }
    
    override func bind() {
        
    }
    
    
}
