//
//  CategoryButtonListView.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import UIKit

import SnapKit

final class CategoryButtonListView: BaseView {
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 17
        view.distribution = .fillEqually
        return view
    }()

    let foodButton: CategoryButton = {
        let view = CategoryButton(category: .food)
        return view
    }()
    
    let characterButton: CategoryButton = {
        let view = CategoryButton(category: .character)
        return view
    }()
    
    let sceneryButton: CategoryButton = {
        let view = CategoryButton(category: .scenery)
        return view
    }()
    
    let nightButton: CategoryButton = {
        let view = CategoryButton(category: .night)
        return view
    }()
    
    let starButton: CategoryButton = {
        let view = CategoryButton(category: .star)
        return view
    }()
    
    override func setupSubviews() {
        addSubview(stackView)
        
        stackView.addArrangedSubviews([
            foodButton,
            characterButton,
            sceneryButton,
            nightButton,
            starButton
        ])
    }
    
    override func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
