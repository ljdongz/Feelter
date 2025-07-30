//
//  FloatingTitleTextField.swift
//  Feelter
//
//  Created by 이정동 on 7/29/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

enum TextFieldOptionButtonType {
    case none
    case passwordToggle
    case image(UIImage)
    case text(String)
}

final class FloatingTitleTextField: BaseView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .deepTurquoise
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.gray75.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .pretendard(size: 14, weight: .medium)
        view.textColor = .gray60
        return view
    }()
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.textColor = .gray15
        view.placeholder = nil
        view.font = .pretendard(size: 14, weight: .medium)
        view.delegate = self
        return view
    }()

    let optionButton: UIButton = {
        let view = UIButton()
        view.setImage(nil, for: .normal)
        view.setTitle(nil, for: .normal)
        return view
    }()
    
    var optionType: TextFieldOptionButtonType = .none {
        didSet {
            updateOptionButton()
        }
    }
    
    var optionButtonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    
    override func setupSubviews() {
        addSubview(containerView)
        
        [titleLabel, textField, optionButton].forEach {
            containerView.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(optionButton.snp.leading).offset(-10)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(10)
            make.trailing.equalTo(optionButton.snp.leading).offset(-10)
        }
        
        optionButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(20)
        }
    }
    
    override func setupActions() {
        setupOptionButtonAction()
    }
}

// MARK: - Private
extension FloatingTitleTextField {
    private func updateOptionButton() {
        switch optionType {
        case .none:
            optionButton.setTitle(nil, for: .normal)
            optionButton.setImage(nil, for: .normal)
            optionButton.isHidden = true
            optionButton.snp.updateConstraints { make in
                make.width.equalTo(0)
            }
            textField.isSecureTextEntry = false

        case .passwordToggle:
            optionButton.setTitle(nil, for: .normal)
            optionButton.setImage(.blackPoint, for: .normal)
            optionButton.isHidden = false
            optionButton.snp.updateConstraints { make in
                make.width.equalTo(20)
            }
            textField.isSecureTextEntry = true

        case .image(let image):
            optionButton.setTitle(nil, for: .normal)
            optionButton.setImage(image, for: .normal)
            optionButton.isHidden = false
            optionButton.snp.updateConstraints { make in
                make.width.equalTo(20)
            }
            textField.isSecureTextEntry = false

        case .text(let text):
            optionButton.setTitle(text, for: .normal)
            optionButton.setImage(nil, for: .normal)
            optionButton.titleLabel?.font = .pretendard(size: 10, weight: .medium)
            optionButton.setTitleColor(.gray60, for: .normal)
            optionButton.isHidden = false
            optionButton.snp.updateConstraints { make in
                make.width.equalTo(optionButton.titleLabel?.intrinsicContentSize.width ?? 0)
            }
            textField.isSecureTextEntry = false
        }
    }
    
    private func setupOptionButtonAction() {
        optionButton.addTarget(self, action: #selector(optionButtonTapped), for: .touchUpInside)
    }
    
    @objc private func optionButtonTapped() {
        switch optionType {
        case .passwordToggle:
            textField.isSecureTextEntry.toggle()
        default:
            optionButtonAction?()
        }
    }
}

// MARK: - UITextFieldDelegate
extension FloatingTitleTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        containerView.backgroundColor = .lightDarkTurquoise
        
        self.titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(optionButton.snp.leading).offset(-10)
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.titleLabel.font = .pretendard(size: 10, weight: .medium)
                self.layoutIfNeeded()
            }
        )
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        containerView.backgroundColor = .deepTurquoise

        guard let text = self.textField.text,
              text.isEmpty else { return }        
        
        self.titleLabel.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(optionButton.snp.leading).offset(-10)
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.titleLabel.font = .pretendard(size: 14, weight: .medium)
                self.layoutIfNeeded()
            }
        )
    }
}
