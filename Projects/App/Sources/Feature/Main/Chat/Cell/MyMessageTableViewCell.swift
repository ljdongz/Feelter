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
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 2
        view.alignment = .trailing
        return view
    }()

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
    
    private let imageLayoutView: ChatImageLayoutView = {
        let view = ChatImageLayoutView()
        view.isHidden = true
        return view
    }()
    
    private let dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray75
        view.font = .pretendard(size: 11, weight: .medium)
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func setupView() {
        selectionStyle = .none
    }

    override func setupSubviews() {
        contentView.addSubviews([
            dateLabel,
            stackView
        ])
        
        stackView.addArrangedSubviews([
            messageContainerView,
            imageLayoutView
        ])
        
        messageContainerView.addSubviews([
            messageLabel
        ])
    }
    
    override func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(stackView.snp.leading).offset(-5)
            make.bottom.equalTo(stackView.snp.bottom)
        }
        
        stackView.snp.makeConstraints { make in
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
        dateLabel.isHidden = !message.showTime
        
        imageLayoutView.isHidden = message.files.isEmpty
        
        if !message.files.isEmpty {
            imageLayoutView.configureImageURLs(message.files)
        }
    }
}
