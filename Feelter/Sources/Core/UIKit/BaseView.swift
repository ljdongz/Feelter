//
//  BaseUIView.swift
//  Feelter
//
//  Created by 이정동 on 7/30/25.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupSubviews()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {}
    func setupSubviews() {}
    func setupConstraints() {}
    func setupActions() {}
}
