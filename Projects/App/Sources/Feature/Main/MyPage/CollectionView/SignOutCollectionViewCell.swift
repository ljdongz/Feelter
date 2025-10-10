//
//  SignOutCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/31/25.
//

import UIKit

import SnapKit

final class SignOutCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "SignOutCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .pretendard(size: 16, weight: .semiBold)
        view.textAlignment = .center
        view.text = "로그아웃"
        view.textColor = .gray30
        return view
    }()
    
    override func setupView() {
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .deepTurquoise
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SignOutCollectionViewCell {
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
