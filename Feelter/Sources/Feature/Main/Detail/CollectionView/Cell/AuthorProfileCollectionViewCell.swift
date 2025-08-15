//
//  AuthorProfileCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import UIKit

import SnapKit

final class AuthorProfileCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "AuthorProfileCollectionViewCell"
    
    private let profileView: ProfileView = {
        let view = ProfileView()
        return view
    }()

    override func setupSubviews() {
        contentView.addSubview(profileView)
    }
    
    override func setupConstraints() {
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(profile: Profile?) {
        profileView.profile = profile
    }
}

extension AuthorProfileCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(72)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 30, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
}
