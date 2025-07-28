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
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.image = .blackPoint
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(image)
        image.snp.makeConstraints { make in
            make.center.equalToSuperview()
            
        }
        
        print(AppConfiguration.url(.baseURL))
        print(AppConfiguration.key(.apiHeaderKey))
    }

    override func addSubviews() {
        
    }
    
    override func configureConstraints() {
        
    }
    
    override func bind() {
        
    }
    
    
}
