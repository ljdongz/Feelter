//
//  SignInView.swift
//  Feelter
//
//  Created by 이정동 on 7/30/25.
//

import UIKit

final class SignInView: BaseView {
    
    // MARK: - UI Properties
    private let titleHeaderLabel: UILabel = {
        let view = UILabel()
        view.text = "Feel the Filter,"
        view.textColor = .gray0
        view.font = .hakgyoansimMulgyeol(size: 22, weight: .regular)
        return view
    }()
    
    private let titleBodyLabel: UILabel = {
        let view = UILabel()
        view.text = "Feelter"
        view.textColor = .gray0
        view.font = .hakgyoansimMulgyeol(size: 40, weight: .bold)
        return view
    }()
    
    let emailTextField: FloatingTitleTextField = {
        let view = FloatingTitleTextField()
        view.trailingButtonType = .none
        view.titleLabel.text = "이메일"
        return view
    }()
    
    let passwordTextField: FloatingTitleTextField = {
        let view = FloatingTitleTextField()
        view.trailingButtonType = .passwordToggle
        view.trailingButton.tintColor = .gray30
        view.titleLabel.text = "비밀번호"
        return view
    }()
    
    let signInButton: UIButton = {
        let view = UIButton()
        view.setTitle("로그인", for: .normal)
        view.setTitleColor(.gray0, for: .normal)
        view.titleLabel?.font = .pretendard(size: 14, weight: .semiBold)
        view.setImage(nil, for: .normal)
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .lightTurquoise.withAlphaComponent(0.2)
        return view
    }()

    let joinButton: UIButton = {
        let view = UIButton()
        view.setTitle("회원가입", for: .normal)
        view.setTitleColor(.gray0, for: .normal)
        view.titleLabel?.font = .pretendard(size: 12, weight: .medium)
        view.setImage(nil, for: .normal)
        view.backgroundColor = .clear
        return view
    }()
    
    private let leftDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray60
        return view
    }()
    
    private let dividerLabel: UILabel = {
        let view = UILabel()
        view.text = "또는"
        view.textColor = .gray60
        view.font = .pretendard(size: 12, weight: .medium)
        return view
    }()

    private let rightDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray60
        return view
    }()

    let appleSignInButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(
            "Apple 로그인",
            attributes: AttributeContainer([
                .font: UIFont.pretendard(size: 14, weight: .semiBold)
            ])
        )
        config.image = .appleLogo
        config.baseForegroundColor = .gray100
        config.baseBackgroundColor = .gray0
        config.cornerStyle = .fixed
        config.background.cornerRadius = 12
        config.imagePadding = 8
        
        let view = UIButton(configuration: config)
        return view
    }()

    let kakaoSignInButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(
            "카카오 로그인",
            attributes: AttributeContainer([
                .font: UIFont.pretendard(size: 14, weight: .semiBold)
            ])
        )
        config.image = .kakaoLogo
        config.baseForegroundColor = .gray100.withAlphaComponent(0.85)
        config.baseBackgroundColor = .kakaoYellow
        config.cornerStyle = .fixed
        config.background.cornerRadius = 12
        config.imagePadding = 8
        
        let view = UIButton(configuration: config)
        return view
    }()
    
    // MARK: - Properties
    private let gradientLayer = CAGradientLayer()
    
    var isSignInButtonEnable: Bool = false {
        didSet {
            signInButton.isUserInteractionEnabled = isSignInButtonEnable
            
            let alpha = isSignInButtonEnable ? 1.0 : 0.2
            signInButton.backgroundColor = .lightTurquoise.withAlphaComponent(alpha)
        }
    }

    
    // MARK: - override
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    override func setupView() {
        gradientLayer.colors = [
            UIColor.brightTurquoise.cgColor,
            UIColor.gray100.cgColor
        ]
        self.layer.addSublayer(gradientLayer)
    }
    
    override func setupSubviews() {
        [
            titleHeaderLabel, titleBodyLabel,
            emailTextField, passwordTextField,
            signInButton, joinButton,
            leftDivider, dividerLabel, rightDivider,
            appleSignInButton, kakaoSignInButton
        ]
            .forEach {
                addSubview($0)
            }
    }
    
    override func setupConstraints() {
        titleHeaderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(180)
            make.centerX.equalToSuperview()
        }
        
        titleBodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleHeaderLabel.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleBodyLabel.snp.bottom).offset(73)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(45)
        }
        
        joinButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        dividerLabel.snp.makeConstraints { make in
            make.top.equalTo(joinButton.snp.bottom).offset(44)
            make.centerX.equalToSuperview()
        }
        
        leftDivider.snp.makeConstraints { make in
            make.centerY.equalTo(dividerLabel.snp.centerY)
            make.leading.equalToSuperview().inset(30)
            make.trailing.equalTo(dividerLabel.snp.leading).offset(-10)
            make.height.equalTo(1)
        }
        
        rightDivider.snp.makeConstraints { make in
            make.centerY.equalTo(dividerLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(30)
            make.leading.equalTo(dividerLabel.snp.trailing).offset(10)
            make.height.equalTo(1)
        }
        
        appleSignInButton.snp.makeConstraints { make in
            make.top.equalTo(dividerLabel.snp.bottom).offset(54)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(45)
        }
        
        kakaoSignInButton.snp.makeConstraints { make in
            make.top.equalTo(appleSignInButton.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(45)
        }
    }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
    SignInViewController()
}
#endif
