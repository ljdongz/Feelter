//
//  FloatingTitleTextView.swift
//  Feelter
//
//  Created by 이정동 on 7/30/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class FloatingTitleTextView: BaseView {
    
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
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.textColor = .gray15
        view.font = .pretendard(size: 14, weight: .medium)
        view.backgroundColor = .clear
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = UIEdgeInsets.zero
        view.delegate = self
        return view
    }()
    
    // MARK: - Setup View
    
    override func setupSubviews() {
        addSubview(containerView)
        
        [titleLabel, textView].forEach {
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
            make.trailing.equalToSuperview().inset(10)
        }
        
        textView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.lessThanOrEqualToSuperview().inset(20)
        }
    }
    
    override func setupActions() {
        setupContainerTapGesture()
    }
}

// MARK: - Private
extension FloatingTitleTextView {
    private func setupContainerTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func containerTapped() {
        textView.becomeFirstResponder()
    }
}

// MARK: - UITextViewDelegate
extension FloatingTitleTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        containerView.backgroundColor = .lightDarkTurquoise
        
        self.titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        self.textView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        containerView.backgroundColor = .deepTurquoise

        guard let text = self.textView.text,
              text.isEmpty else { return }        
        
        self.titleLabel.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        self.textView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.lessThanOrEqualToSuperview().inset(20)
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
