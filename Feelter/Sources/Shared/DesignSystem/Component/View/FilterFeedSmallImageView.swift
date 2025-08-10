//
//  FilterFeedSmallImageView.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import UIKit

import SnapKit

final class FilterFeedSmallImageView: BaseView {
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let likeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = .likeEmpty
        view.tintColor = .gray60
        return view
    }()

    override func setupSubviews() {
        addSubview(imageView)
        
        imageView.addSubview(likeImageView)
    }
    
    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        likeImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(8)
            make.size.equalTo(24)
        }
    }
}
