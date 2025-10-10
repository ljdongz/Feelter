//
//  MainProfileCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/22/25.
//

import UIKit

import RxSwift
import SnapKit

typealias MainProfileCellItem = MainProfileCollectionViewCell.Item

final class MainProfileCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "MainProfileCollectionViewCell"
    
    struct Item: Hashable {
        let profileImageURL: String
        let nickname: String
        let name: String?
        let email: String
    }
    
    private let profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 36
        view.clipsToBounds = true
        return view
    }()
    
    private let labelStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 5
        return view
    }()

    private let nicknameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray30
        view.font = .hakgyoansimMulgyeol(size: 20, weight: .bold)
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray75
        view.font = .pretendard(size: 14, weight: .medium)
        return view
    }()
    
    private let emailLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray75
        view.font = .pretendard(size: 14, weight: .medium)
        return view
    }()

    private let horizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 15
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()

    let editProfileContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .deepTurquoise
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let editProfileLabel: UILabel = {
        let view = UILabel()
        view.text = "프로필 편집"
        view.textColor = .gray30
        view.font = .pretendard(size: 13, weight: .medium)
        return view
    }()

    let chatRoomsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .deepTurquoise
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let chatRoomsLabel: UILabel = {
        let view = UILabel()
        view.text = "채팅 목록"
        view.textColor = .gray30
        view.font = .pretendard(size: 13, weight: .medium)
        return view
    }()
    
    private(set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func setupSubviews() {
        contentView.addSubviews([
            profileImageView,
            labelStackView,
            horizontalStackView
        ])
        
        labelStackView.addArrangedSubviews([
            nicknameLabel,
            nameLabel,
            emailLabel
        ])
        
        horizontalStackView.addArrangedSubviews([
            editProfileContainerView,
            chatRoomsContainerView
        ])
        
        editProfileContainerView.addSubviews([
            editProfileLabel
        ])
        
        chatRoomsContainerView.addSubviews([
            chatRoomsLabel
        ])
    }
    
    override func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(72)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.trailing.equalToSuperview()
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(25)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(30)
        }
        
        editProfileLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        chatRoomsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureCell(item: MainProfileCellItem) {
        profileImageView.image = .sampleImage
        nicknameLabel.text = item.nickname
        nameLabel.text = item.name
        emailLabel.text = item.email
        
        if let name = item.name, !name.isEmpty {
            nameLabel.isHidden = false
        } else {
            nameLabel.isHidden = true
        }
    }
}

extension MainProfileCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(120)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(120)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 20, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
}
