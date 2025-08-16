//
//  ChatMessageInputField.swift
//  Feelter
//
//  Created by 이정동 on 8/13/25.
//

import UIKit

import SnapKit

final class ChatMessageInputField: BaseView {

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .blackTurquoise
        return view
    }()

    private let inputFieldContainerView: UIView = {
        let view = UIView()
        return view
    }()

    let plusButton: UIView = {
        let view = UIView()
        view.backgroundColor = .deepTurquoise
        view.layer.cornerRadius = 15
        return view
    }()

    private let plusImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray45
        view.image = .plus
        return view
    }()
    
    lazy var messageInputTextView: UITextView = {
        let view = UITextView()
        view.textColor = .gray45
        view.font = .pretendard(size: 15, weight: .medium)
        view.textContainerInset = .init(top: 9, left: 11, bottom: 9, right: 11)
        view.textAlignment = .left
        view.backgroundColor = .deepTurquoise
        view.layer.cornerRadius = 18
        view.isScrollEnabled = false
        view.delegate = self
        return view
    }()

    let sendButton: UIView = {
        let view = UIView()
        view.backgroundColor = .deepTurquoise
        view.layer.cornerRadius = 15
        view.isUserInteractionEnabled = false
        view.alpha = 0.5
        return view
    }()

    private let sendImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray45
        view.image = .message
        return view
    }()
    
    private var textViewHeightConstraint: Constraint?
    private let minHeight: CGFloat = 36
    private let maxHeight: CGFloat = 120
    
    var message: String {
        get {
            messageInputTextView.text
        }
        set {
            messageInputTextView.text = newValue
            updateSendButtonEnabled()
        }
    }
    
    override func setupSubviews() {
        addSubviews([
            divider,
            inputFieldContainerView
        ])
        
        inputFieldContainerView.addSubviews([
            plusButton,
            messageInputTextView,
            sendButton
        ])
        
        plusButton.addSubview(plusImageView)
        sendButton.addSubview(sendImageView)
    }
    
    override func setupConstraints() {
        // 구분선
        divider.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalTo(inputFieldContainerView.snp.top)
            make.height.equalTo(1)
        }
        
        // 메시지 입력 필드 컨테이너
        inputFieldContainerView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(divider.snp.bottom)
        }
        
        // 입력 필드 좌측 추가 버튼
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.leading.equalToSuperview().inset(10)
            make.bottom.equalTo(messageInputTextView.snp.bottom).offset(-3)
        }
        
        // 추가 이미지
        plusImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(16)
        }
        
        // 입력 필드
        messageInputTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalTo(plusButton.snp.trailing).offset(10)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
            make.bottom.equalToSuperview().inset(34)
            textViewHeightConstraint = make.height.equalTo(minHeight).constraint
        }
        
        // 입력 필드 우측 전송 버튼
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(messageInputTextView.snp.bottom).offset(-3)
        }
        
        // 전송 이미지
        sendImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-1)
            make.centerY.equalToSuperview().offset(1)
            make.size.equalTo(16)
        }
    }
}

// MARK: - UITextViewDelegate
extension ChatMessageInputField: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {

        // 전송버튼 활성화 상태 업데이트
        updateSendButtonEnabled()
        
        // 텍스트 뷰 높이 동적 조절
        updateTextViewHeightConstraint()
    }
    
    private func updateSendButtonEnabled() {
        let isEnabled = !messageInputTextView.text.isEmpty
        sendButton.isUserInteractionEnabled = isEnabled
        sendButton.alpha = isEnabled ? 1 : 0.5
    }
    
    private func updateTextViewHeightConstraint() {
        guard self.messageInputTextView.bounds.width > 0 else { return }
        
        // 현재 텍스트에 맞는 높이 계산
        let fixedWidth = messageInputTextView.bounds.width
        let estimatedSize = messageInputTextView.sizeThatFits(.init(width: fixedWidth, height: .greatestFiniteMagnitude))
        let newHeight = max(minHeight, min(estimatedSize.height, maxHeight))
        
        // 제약조건 업데이트
        textViewHeightConstraint?.layoutConstraints.first?.constant = newHeight
        
        messageInputTextView.isScrollEnabled = estimatedSize.height > maxHeight
        
        // 부모 뷰의 레이아웃 업데이트
        self.superview?.layoutIfNeeded()
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    ChatMessageInputField()
}
#endif
