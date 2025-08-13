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
    
    let textView: UITextView = {
        let view = UITextView()
        view.textColor = .gray45
        view.font = .pretendard(size: 15, weight: .medium)
        view.textContainerInset = .init(top: 9, left: 11, bottom: 9, right: 11)
        view.textAlignment = .left
        view.tintColor = .gray45
        view.backgroundColor = .deepTurquoise
        view.layer.cornerRadius = 18
        return view
    }()

    let sendButton: UIView = {
        let view = UIView()
        view.backgroundColor = .deepTurquoise
        view.layer.cornerRadius = 15
        return view
    }()

    private let sendImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray45
        view.image = .message
        return view
    }()
    
    override func setupSubviews() {
        addSubviews([
            divider,
            inputFieldContainerView
        ])
        
        inputFieldContainerView.addSubviews([
            plusButton,
            textView,
            sendButton
        ])
        
        plusButton.addSubview(plusImageView)
        sendButton.addSubview(sendImageView)
    }
    
    override func setupConstraints() {
        // 구분선
        divider.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(inputFieldContainerView.snp.top)
            make.height.equalTo(1)
        }
        
        // 메시지 입력 필드 컨테이너
        inputFieldContainerView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        // 입력 필드 좌측 추가 버튼
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.leading.equalToSuperview().inset(10)
            make.top.equalTo(textView.snp.top).offset(3)
        }
        
        // 추가 이미지
        plusImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(16)
        }
        
        // 입력 필드
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalTo(plusButton.snp.trailing).offset(10)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(36)
        }
        
        // 입력 필드 우측 전송 버튼
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(textView.snp.top).offset(3)
        }
        
        // 전송 이미지
        sendImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-1)
            make.centerY.equalToSuperview().offset(1)
            make.size.equalTo(16)
        }
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    ChatMessageInputField()
}
#endif
