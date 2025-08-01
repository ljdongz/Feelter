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

enum TextFieldStatus {
    case none
    case success
    case fail
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

    let trailingButton: UIButton = {
        let view = UIButton()
        view.setImage(nil, for: .normal)
        view.setTitle(nil, for: .normal)
        view.tintColor = UIColor(resource: .gray0)
        return view
    }()
    
    var trailingButtonType: TextFieldOptionButtonType = .none {
        didSet {
            updateOptionButton()
        }
    }
    
    var textFieldStatus: TextFieldStatus = .none {
        didSet {
            updateTextFieldStatus()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    
    override func setupSubviews() {
        addSubview(containerView)
        
        [titleLabel, textField, trailingButton].forEach {
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
            make.trailing.equalTo(trailingButton.snp.leading).offset(-10)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(10)
            make.trailing.equalTo(trailingButton.snp.leading).offset(-10)
        }
        
        trailingButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(20)
        }
    }
    
    override func setupActions() {
        setupOptionButtonAction()
        setupContainerTapGesture()
    }
}

// MARK: - Private
private extension FloatingTitleTextField {
    func updateOptionButton() {
        switch trailingButtonType {
        case .none:
            trailingButton.setTitle(nil, for: .normal)
            trailingButton.setImage(nil, for: .normal)
            trailingButton.isHidden = true
            trailingButton.snp.updateConstraints { make in
                make.width.equalTo(0)
            }
            textField.isSecureTextEntry = false

        case .passwordToggle:
            trailingButton.setTitle(nil, for: .normal)
            trailingButton.setImage(.eye, for: .normal)
            trailingButton.isHidden = false
            trailingButton.snp.updateConstraints { make in
                make.width.equalTo(20)
            }
            textField.isSecureTextEntry = true

        case .image(let image):
            trailingButton.setTitle(nil, for: .normal)
            trailingButton.setImage(image, for: .normal)
            trailingButton.isHidden = false
            trailingButton.snp.updateConstraints { make in
                make.width.equalTo(20)
            }
            textField.isSecureTextEntry = false

        case .text(let text):
            trailingButton.setTitle(text, for: .normal)
            trailingButton.setImage(nil, for: .normal)
            trailingButton.titleLabel?.font = .pretendard(size: 10, weight: .medium)
            trailingButton.setTitleColor(.gray60, for: .normal)
            trailingButton.isHidden = false
            trailingButton.snp.updateConstraints { make in
                make.width.equalTo(trailingButton.titleLabel?.intrinsicContentSize.width ?? 0)
            }
            textField.isSecureTextEntry = false
        }
    }
    
    func updateTextFieldStatus() {
        switch textFieldStatus {
        case .success:
            containerView.layer.borderColor = UIColor.green.cgColor
        case .fail:
            containerView.layer.borderColor = UIColor.red.cgColor
        case .none:
            containerView.layer.borderColor = UIColor.gray75.cgColor
        }
    }
    
    func setupOptionButtonAction() {
        trailingButton.addTarget(self, action: #selector(optionButtonTapped), for: .touchUpInside)
    }
    
    func setupContainerTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    @objc func containerTapped() {
        textField.becomeFirstResponder()
    }
    
    @objc func optionButtonTapped() {
        switch trailingButtonType {
        case .passwordToggle:
            textField.isSecureTextEntry.toggle()
            let image = textField.isSecureTextEntry ? UIImage.eye : UIImage.blind
            trailingButton.setImage(image, for: .normal)
        default:
            break
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
            make.trailing.equalTo(trailingButton.snp.leading).offset(-10)
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
            make.trailing.equalTo(trailingButton.snp.leading).offset(-10)
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
