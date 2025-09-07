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

    private let contentVerticalStackView: UIStackView = {
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
    
    private let contentHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 5
        view.alignment = .bottom
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 2
        view.alignment = .leading
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
    
    private let imageLayoutView: ChatImageLayoutView = {
        let view = ChatImageLayoutView()
        view.isHidden = true
        return view
    }()
    
    private let dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray75
        view.font = .pretendard(size: 11, weight: .medium)
        view.textAlignment = .left
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }()

    override func setupView() {
        selectionStyle = .none
    }
    
    override func setupSubviews() {
        contentView.addSubviews([
            profileImageView,
            contentVerticalStackView,
        ])
        
        contentVerticalStackView.addArrangedSubviews([
            nameLabel,
            contentHorizontalStackView
        ])
        
        contentHorizontalStackView.addArrangedSubviews([
            stackView,
            dateLabel
        ])
        
        stackView.addArrangedSubviews([
            messageContainerView,
            imageLayoutView
        ])
        
        messageContainerView.addSubview(messageLabel)
    }
    
    override func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(2)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(35)
        }
        
        contentVerticalStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(2)
            make.leading.equalToSuperview().inset(65)
            make.trailing.lessThanOrEqualToSuperview().inset(45)
            make.bottom.equalToSuperview().inset(2)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
    }
    
    func configureCell(message: MessageItem) {
        messageLabel.text = message.content
        dateLabel.text = message.timestamp.formatted(.timeOnly)
        
        // 프로필 표시 여부에 따른 UI 처리
        if message.showProfile {
            showProfileElements(message: message)
        } else {
            hideProfileElements()
        }
        
        dateLabel.isHidden = !message.showTime
        
        imageLayoutView.isHidden = message.files.isEmpty
        
        if !message.files.isEmpty {
            imageLayoutView.configureImageURLs(message.files)
        }
    }
    
    private func showProfileElements(message: MessageItem) {
        profileImageView.isHidden = false
        nameLabel.isHidden = false
        
        nameLabel.text = message.sender.name
        ImageLoader.shared.applyAuthenticatedImage(
            for: profileImageView,
            path: message.sender.profileImageURL ?? "",
            cachePolicy: .diskCache(expiration: .chatMessageFile),
            failureImage: .anonymous
        )
    }
    
    private func hideProfileElements() {
        profileImageView.isHidden = true
        nameLabel.isHidden = true
    }
}
