//
//  SliderControlCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import UIKit

import SnapKit

final class ImageSliderFooterView: UICollectionReusableView {
    
    static let identifier = "ImageSliderFooterView"
    
    private let beforeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray75.withAlphaComponent(0.5)
        view.clipsToBounds = true
        return view
    }()
    
    private let beforeLabel: UILabel = {
        let view = UILabel()
        view.text = "Before"
        view.textColor = .gray60
        view.font = .pretendard(size: 11, weight: .semiBold)
        view.textAlignment = .center
        return view
    }()

    private let anchorContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray75.withAlphaComponent(0.5)
        view.layer.borderColor = UIColor.gray75.cgColor
        view.layer.borderWidth = 2
        return view
    }()

    private let anchorImageView: UIImageView = {
        let view = UIImageView()
        view.image = .polygon
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray60
        return view
    }()

    private let afterContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray75.withAlphaComponent(0.5)
        view.clipsToBounds = true
        return view
    }()
    
    private let afterLabel: UILabel = {
        let view = UILabel()
        view.text = "After"
        view.textColor = .gray60
        view.font = .pretendard(size: 11, weight: .semiBold)
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        beforeContainerView.layer.cornerRadius = beforeContainerView.bounds.height / 2
        afterContainerView.layer.cornerRadius = afterContainerView.bounds.height / 2
        anchorContainerView.layer.cornerRadius = anchorContainerView.bounds.height / 2
    }
    
    private func setupSubviews() {
        addSubviews([
            beforeContainerView,
            anchorContainerView,
            afterContainerView
        ])
        
        beforeContainerView.addSubview(beforeLabel)
        anchorContainerView.addSubview(anchorImageView)
        afterContainerView.addSubview(afterLabel)
    }
    
    private func setupConstraints() {
        
        beforeContainerView.snp.makeConstraints { make in
            make.trailing.equalTo(anchorContainerView.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
            make.width.equalTo(48)
        }
        
        beforeLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.centerX.equalToSuperview()
        }
        
        anchorContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(24)
        }
        
        anchorImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-1)
            make.size.equalTo(10)
        }
        
        afterContainerView.snp.makeConstraints { make in
            make.leading.equalTo(anchorContainerView.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
            make.width.equalTo(48)
        }
        
        afterLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.centerX.equalToSuperview()
        }
    }
}
