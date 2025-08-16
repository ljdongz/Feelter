//
//  BaseButtonCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/12/25.
//

import UIKit

import SnapKit

final class BaseButtonCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "BaseButtonCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .pretendard(size: 20, weight: .semiBold)
        view.textAlignment = .center
        return view
    }()
    
    override func setupView() {
        contentView.layer.cornerRadius = 8
        
        updateActiveState(false)
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(title: String) {
        titleLabel.text = title
    }
    
    func updateActiveState(_ isActive: Bool) {
        titleLabel.textColor = isActive ? .gray30 : .gray75
        contentView.backgroundColor = .lightTurquoise.withAlphaComponent(isActive ? 1.0 : 0.2)
    }
}

extension BaseButtonCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(46)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 30, leading: 20, bottom: 0, trailing: 20)
        return section
    }
}
