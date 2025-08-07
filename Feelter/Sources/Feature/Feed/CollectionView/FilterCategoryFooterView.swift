//
//  FilterCategoryFooterView.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import UIKit

import SnapKit

final class FilterCategoryFooterView: UICollectionReusableView {
        
    static let identifier = "FilterCategoryFooterView"
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()

    private let latestButton: CapsuleButton = {
        let view = CapsuleButton()
        view.title = "최신순"
        view.isSelected = true
        return view
    }()
    
    private let popularistButton: CapsuleButton = {
        let view = CapsuleButton()
        view.title = "인기순"
        view.isSelected = false
        return view
    }()
    
    private let purchaseButton: CapsuleButton = {
        let view = CapsuleButton()
        view.title = "구매순"
        view.isSelected = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(containerView)
        
        containerView.addSubviews([
            latestButton,
            popularistButton,
            purchaseButton
        ])
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        purchaseButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        popularistButton.snp.makeConstraints { make in
            make.trailing.equalTo(purchaseButton.snp.leading).offset(-8)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        latestButton.snp.makeConstraints { make in
            make.trailing.equalTo(popularistButton.snp.leading).offset(-8)
            make.verticalEdges.equalToSuperview().inset(8)
        }
    }
}
