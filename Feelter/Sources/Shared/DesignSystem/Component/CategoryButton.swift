//
//  CategoryButton.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import UIKit

import SnapKit

final class CategoryButton: BaseView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray60.withAlphaComponent(0.5).cgColor
        view.backgroundColor = .gray75.withAlphaComponent(0.5)
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 2
        view.alignment = .center
        return view
    }()

    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .gray60
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray60
        view.font = .pretendard(size: 10, weight: .semiBold)
        return view
    }()
    
    private let category: FilterCategory
    
    init(category: FilterCategory) {
        self.category = category
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        titleLabel.text = category.rawValue
        
        switch category {
        case .food:
            iconImageView.image = .food
        case .character:
            iconImageView.image = .people
        case .scenery:
            iconImageView.image = .landscape
        case .night:
            iconImageView.image = .night
        case .star:
            iconImageView.image = .star
        }
    }
    
    override func setupSubviews() {
        addSubview(containerView)
        
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubviews([
            iconImageView, titleLabel
        ])
    }
    
    override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(56)
        }
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    CategoryButton(category: .character)
}
#endif
