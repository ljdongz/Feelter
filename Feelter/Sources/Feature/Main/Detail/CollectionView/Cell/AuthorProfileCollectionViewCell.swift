//
//  AuthorProfileCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import UIKit

import RxSwift
import SnapKit

typealias AuthorProfileCellItem = AuthorProfileCollectionViewCell.Item

final class AuthorProfileCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "AuthorProfileCollectionViewCell"
    
    struct Item: Hashable {
        let userID: String
        let profileImageURL: String?
        let name: String?
        let nickname: String
    }
    
    private let profileView: ProfileView = {
        let view = ProfileView()
        return view
    }()
    
    let chatButton: UIView = {
        let view = UIView()
        view.backgroundColor = .deepTurquoise
        view.layer.cornerRadius = 8
        return view
    }()

    private let chatImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = .message
        view.tintColor = .gray30
        return view
    }()
    
    private(set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }

    override func setupSubviews() {
        contentView.addSubviews([
            profileView,
            chatButton
        ])
        
        chatButton.addSubview(chatImageView)
    }
    
    override func setupConstraints() {
        profileView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.trailing.equalTo(chatButton.snp.leading).offset(-15)
        }
        
        chatButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.size.equalTo(44)
            make.centerY.equalToSuperview()
        }
        
        chatImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(32)
        }
    }
    
    func configureCell(item: AuthorProfileCellItem) {
        profileView.configureUI(
            imageURL: item.profileImageURL ?? "",
            name: item.name ?? "윤새싹",
            nickname: item.nickname
        )
        
        let currentUserID = UserDefaults.standard.string(forKey: "userID")
        chatButton.isHidden = item.userID == currentUserID
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
