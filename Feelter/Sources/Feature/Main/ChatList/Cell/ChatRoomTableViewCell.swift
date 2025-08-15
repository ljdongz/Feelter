//
//  ChatRoomListTableViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/13/25.
//

import UIKit

import SnapKit

typealias ChatRoomCellItem = ChatRoomTableViewCell.Item

final class ChatRoomTableViewCell: BaseTableViewCell {
    
    static let identifier = "ChatRoomTableViewCell"
    
    struct Item: Hashable {
        let profileImageURL: String?
        let name: String
        let message: String
        let date: String
        let unreadCount: Int
    }

    private let profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let contentsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 4
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray30
        view.font = .hakgyoansimMulgyeol(size: 16, weight: .bold)
        return view
    }()

    private let messageLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray75
        view.font = .pretendard(size: 13, weight: .medium)
        view.textAlignment = .left
        view.numberOfLines = 2
        return view
    }()

    private let dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray75
        view.font = .pretendard(size: 11, weight: .medium)
        return view
    }()
    
    private let unreadBadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = .brightTurquoise
        view.layer.cornerRadius = 10
        view.isHidden = true
        return view
    }()
    
    private let unreadCountLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .pretendard(size: 10, weight: .bold)
        view.textAlignment = .center
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = nil
    }
    
    override func setupView() {
        selectionStyle = .none
    }
    
    override func setupSubviews() {
        contentView.addSubviews([
            profileImageView,
            contentsStackView,
            dateLabel,
            unreadBadgeView
        ])
        
        unreadBadgeView.addSubview(unreadCountLabel)
        
        contentsStackView.addArrangedSubviews([
            nameLabel,
            messageLabel
        ])
    }

    override func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(60)
        }
        
        contentsStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(90)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(10)
            make.trailing.equalToSuperview().inset(20)
        }
        
        unreadBadgeView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(6)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(20)
        }
        
        unreadCountLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(6)
        }
    }
    
    func configureCell(_ item: ChatRoomCellItem) {
        profileImageView.image = .sample
        
        nameLabel.text = item.name
        messageLabel.text = item.message
        dateLabel.text = item.date
        
        if item.unreadCount > 0 {
            unreadBadgeView.isHidden = false
            unreadCountLabel.text = item.unreadCount >= 999 ? "999+" : "\(item.unreadCount)"
        } else {
            unreadBadgeView.isHidden = true
        }
    }
}
