//
//  MyMessageTableViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import UIKit

import SnapKit

final class MyMessageTableViewCell: BaseTableViewCell {
    
    static let identifier = "MyMessageTableViewCell"

    private let messageContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .brightTurquoise
        return view
    }()

    private let messageLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray15
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
            dateLabel,
            messageContainerView
        ])
        
        messageContainerView.addSubviews([
            messageLabel
        ])
    }
    
    override func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(messageContainerView.snp.leading).offset(-5)
            make.bottom.equalTo(messageContainerView.snp.bottom).offset(-2)
        }
        
        messageContainerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(2)
            make.trailing.equalToSuperview().inset(20)
            make.leading.greaterThanOrEqualToSuperview().inset(130)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
    }
    
    func configureCell(message: MessageItem) {
        messageLabel.text = message.content
        dateLabel.text = message.timestamp.formatted(.timeOnly)
    }
}
