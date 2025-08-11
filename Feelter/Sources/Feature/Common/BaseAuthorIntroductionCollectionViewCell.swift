//
//  TodayAuthorIntroductionCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/5/25.
//

import UIKit

import SnapKit

final class BaseAuthorIntroductionCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "BaseAuthorIntroductionCollectionViewCell"
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        view.alignment = .leading
        return view
    }()
    
    private let headerTitle: UILabel = {
        let view = UILabel()
        view.textColor = .gray60
        view.font = .hakgyoansimMulgyeol(size: 14, weight: .regular)
        view.numberOfLines = 0
        return view
    }()

    private let bodyTitle: UILabel = {
        let view = UILabel()
        view.textColor = .gray60
        view.font = .pretendard(size: 12, weight: .regular)
        view.numberOfLines = 0
        
        return view
    }()

    override func setupSubviews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews([
            headerTitle,
            bodyTitle
        ])
    }
    
    override func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configureCell(header: String? = nil, body: String) {
        if let header {
            headerTitle.text = "\"\(header)\""
            headerTitle.isHidden = false
        } else {
            headerTitle.isHidden = true
        }
        bodyTitle.text = body
    }
}

extension BaseAuthorIntroductionCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(80)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 130, trailing: 20)
        
        return section
    }
}
