//
//  ProfileView.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import UIKit

import SnapKit

final class ProfileView: BaseView {

    private lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 36
        return view
    }()
    
    private let profileInfoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 8
        return view
    }()
    
    private let authorName: UILabel = {
        let view = UILabel()
        view.textColor = .gray30
        view.font = .hakgyoansimMulgyeol(size: 20, weight: .bold)
        return view
    }()

    private let authorNickname: UILabel = {
        let view = UILabel()
        view.textColor = .gray75
        view.font = .pretendard(size: 16, weight: .medium)
        return view
    }()
    
    var profile: Profile? {
        didSet {
            updateUI(profile: profile)
        }
    }
    
    override func setupSubviews() {
        addSubviews([
            profileImageView,
            profileInfoStackView
        ])
        
        profileInfoStackView.addArrangedSubviews([
            authorName,
            authorNickname
        ])
    }
    
    override func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(72)
            make.leading.verticalEdges.equalToSuperview()
        }
        
        profileInfoStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    private func updateUI(profile: Profile?) {
        profileImageView.image = .sample
        authorName.text = "윤새싹"
        authorNickname.text = "SESAC YOON"
    }
}
