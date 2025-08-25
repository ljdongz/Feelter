//
//  CircleImageView.swift
//  Feelter
//
//  Created by 이정동 on 8/25/25.
//

import UIKit

import SnapKit

final class IconTextRowView: BaseView {

    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 13
        view.backgroundColor = .brightTurquoise
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray30
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray60
        view.font = .pretendard(size: 14, weight: .medium)
        view.textAlignment = .left
        return view
    }()

    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    override func setupSubviews() {
        addSubviews([
            backgroundView,
            titleLabel
        ])
        backgroundView.addSubview(imageView)
    }
    
    override func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.size.equalTo(26)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(14)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backgroundView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
