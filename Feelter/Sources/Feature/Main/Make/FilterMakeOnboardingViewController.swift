//
//  MakeFilterOnboardingViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/25/25.
//

import UIKit

import SnapKit

final class FilterMakeOnboardingViewController: RxBaseViewController {

    private let headerImageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blackTurquoise.withAlphaComponent(0.6)
        view.layer.cornerRadius = 24
        view.layer.borderColor = UIColor.deepTurquoise.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private let headerImageView: UIImageView = {
        let view = UIImageView()
        view.image = .filterFill
        view.tintColor = .gray75
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "나만의 필터를\n만들어 보세요"
        view.textAlignment = .center
        view.numberOfLines = 2
        view.textColor = .gray30
        view.font = .hakgyoansimMulgyeol(size: 30, weight: .bold)
        return view
    }()
    
    private let subTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "창의적인 필터를 직접 만들고\n다른 사용자들과 공유해보세요"
        view.textColor = .gray60
        view.font = .pretendard(size: 16, weight: .semiBold)
        view.textAlignment = .center
        view.numberOfLines = 2
        return view
    }()
    
    private let verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        view.alignment = .leading
        view.distribution = .fillEqually
        return view
    }()
    
    private let firstRowItem: IconTextRowView = {
        let view = IconTextRowView()
        view.image = .starBasic
        view.title = "독창적인 필터 제작"
        return view
    }()

    private let secondRowItem: IconTextRowView = {
        let view = IconTextRowView()
        view.image = .share
        view.title = "커뮤니티와 공유"
        return view
    }()
    
    private let thirdRowItem: IconTextRowView = {
        let view = IconTextRowView()
        view.image = .check
        view.title = "간편한 제작 과정"
        return view
    }()
    
    private lazy var createButton: UIButton = {
        let view = UIButton()
        view.setTitle("필터 만들기", for: .normal)
        view.setTitleColor(.gray30, for: .normal)
        view.titleLabel?.font = .pretendard(size: 18, weight: .bold)
        view.backgroundColor = .brightTurquoise
        view.layer.cornerRadius = 12
        view.addTarget(self, action: #selector(createButtonDidTapped), for: .touchUpInside)
        return view
    }()


    override func setupSubviews() {
        view.addSubviews([
            headerImageContainerView,
            titleLabel,
            subTitleLabel,
            verticalStackView,
            createButton
        ])
        
        headerImageContainerView.addSubview(headerImageView)
        
        verticalStackView.addArrangedSubviews([
            firstRowItem,
            secondRowItem,
            thirdRowItem
        ])
    }
    
    override func setupConstraints() {
        headerImageContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }
        
        headerImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerImageContainerView.snp.bottom).offset(47)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
        }
        
        createButton.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(50)
            make.horizontalEdges.equalToSuperview().inset(70)
            make.height.equalTo(52)
        }
    }
    
    @objc func createButtonDidTapped() {
        let vc = FilterMakeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: FilterMakeOnboardingViewController())
}
#endif
