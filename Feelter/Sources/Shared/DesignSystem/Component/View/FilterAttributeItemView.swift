//
//  FilterAttributeItemView.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import UIKit

import SnapKit

final class FilterAttributeItemView: BaseView {
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = .brightness
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray30
        return view
    }()
    
    private let valueLabel: UILabel = {
        let view = UILabel()
        view.text = "-99.0"
        view.textColor = .gray75
        view.font = .pretendard(size: 14, weight: .bold)
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.numberOfLines = 1
        return view
    }()
    
    var attributeType: FilterAttributeType? {
        didSet {
            iconImageView.image = attributeType?.image
        }
    }
    
    var value: Double? {
        didSet {
            valueLabel.text = "\(value ?? 0.0)"
        }
    }

    override func setupSubviews() {
        addSubviews([
            iconImageView,
            valueLabel
        ])
    }
    
    override func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(32)
            make.centerX.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
}
