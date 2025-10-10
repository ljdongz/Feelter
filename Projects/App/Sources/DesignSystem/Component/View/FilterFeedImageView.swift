//
//  FilterFeedImageView.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import UIKit

import SnapKit

final class FilterFeedImageView: BaseView {
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray30
        view.font = .hakgyoansimMulgyeol(size: 14, weight: .regular)
        return view
    }()
    
    let likeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = .likeEmpty
        view.tintColor = .gray60
        return view
    }()
    
    let likeCountLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray30
        view.font = .pretendard(size: 12, weight: .semiBold)
        return view
    }()

    override func setupSubviews() {
        addSubview(imageView)
        imageView.addSubviews([
            titleLabel,
            likeImageView,
            likeCountLabel
        ])
    }
    
    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(12)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(12)
        }
        
        likeImageView.snp.makeConstraints { make in
            make.trailing.equalTo(likeCountLabel.snp.leading).offset(-2)
            make.centerY.equalTo(likeCountLabel.snp.centerY)
            make.size.equalTo(16)
        }
    }
}
