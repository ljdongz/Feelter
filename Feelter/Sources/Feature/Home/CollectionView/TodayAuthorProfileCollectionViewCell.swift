//
//  TodayAuthorProfileCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/5/25.
//

import UIKit

import SnapKit

final class TodayAuthorProfileCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier: String = "TodayAuthorProfileCollectionViewCell"
    
    private lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 36
        return view
    }()
    
    private let profileInfoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 8
        return view
    }()
    
    private let authorName: UILabel = {
        let view = UILabel()
        view.text = "작가 이름"
        view.textColor = .gray30
        view.font = .hakgyoansimMulgyeol(size: 20, weight: .bold)
        return view
    }()

    private let authorNickname: UILabel = {
        let view = UILabel()
        view.text = "작가 닉네임"
        view.textColor = .gray75
        view.font = .pretendard(size: 16, weight: .medium)
        return view
    }()
    
    override func setupSubviews() {
        contentView.addSubviews([
            profileImageView,
            profileInfoStackView
        ])
        
        profileInfoStackView.addArrangedSubviews([
            authorName,
            authorNickname
        ])
    }
    
    override func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(72)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        profileInfoStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
    }
    
    func configureCell(_ profile: Profile) {
        profileImageView.image = .sample
        authorName.text = profile.name
        authorNickname.text = profile.nickname
    }
}

extension TodayAuthorProfileCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(200),
                heightDimension: .absolute(72)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(59)),
            
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 8, leading: 20, bottom: 0, trailing: 20)
    
        return section
    }
}
