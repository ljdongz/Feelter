//
//  DateSeparatorTableViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import UIKit

import SnapKit

final class DateSeparatorTableViewCell: BaseTableViewCell {
    
    static let identifier = "DateSeparatorTableViewCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray0.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        return view
    }()

    private let dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray45
        view.font = .pretendard(size: 11, weight: .medium)
        return view
    }()

    override func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)
    }
    
    override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.height.equalTo(25)
            make.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview().inset(6)
        }
    }
    
    func configureCell(_ date: String) {
        dateLabel.text = date
    }
}
