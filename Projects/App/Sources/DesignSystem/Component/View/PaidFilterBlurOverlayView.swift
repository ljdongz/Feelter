//
//  PaidFilterBlurOverlayView.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import UIKit

import SnapKit

final class PaidFilterBlurOverlayView: BaseView {
    
    // MARK: - UI Components
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        return effectView
    }()
    
    private let contentContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let lockIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .lock
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray45
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "결제가 필요한 유료 필터입니다"
        label.font = .pretendard(size: 16, weight: .bold)
        label.textColor = .gray45
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Setup Methods
    override func setupSubviews() {
        addSubviews([
            blurEffectView,
            contentContainerView
        ])
        
        contentContainerView.addSubviews([
            lockIcon,
            titleLabel
        ])
    }
    
    override func setupConstraints() {
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        lockIcon.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(lockIcon.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
