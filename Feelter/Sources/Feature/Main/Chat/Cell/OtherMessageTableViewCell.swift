//
//  OtherMessageTableViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import UIKit

import SnapKit

final class OtherMessageTableViewCell: BaseTableViewCell {
    
    static let identifier = "OtherMessageTableViewCell"

    private lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 17.5
        return view
    }()

    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 5
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray60
        view.font = .hakgyoansimMulgyeol(size: 14, weight: .bold)
        view.setContentHuggingPriority(.required, for: .vertical)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        return view
    }()

    private let messageContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .blackTurquoise
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()

    private let messageLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray60
        view.font = .pretendard(size: 14, weight: .medium)
        view.textAlignment = .left
        view.numberOfLines = 10
        return view
    }()
    
    private let dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray75
        view.font = .pretendard(size: 11, weight: .medium)
        return view
    }()

    override func setupView() {
        selectionStyle = .none
    }
    
    override func setupSubviews() {
        contentView.addSubviews([
            profileImageView,
            contentStackView,
            dateLabel
        ])
        
        contentStackView.addArrangedSubviews([
            nameLabel,
            messageContainerView
        ])
        
        messageContainerView.addSubview(messageLabel)
    }
    
    override func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(2)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(35)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(2)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(85)
            make.bottom.equalToSuperview().inset(2)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentStackView.snp.trailing).offset(5)
            make.bottom.equalTo(contentStackView.snp.bottom).offset(-2)
        }
    }
    
    func configureCell(message: MessageItem) {
        messageLabel.text = message.content
        dateLabel.text = message.timestamp.formatted(.timeOnly)
        
        nameLabel.text = message.sender.name
        ImageLoader.applyAuthenticatedImage(
            for: profileImageView,
            path: message.sender.profileImageURL ?? ""
        )
    }
}
