//
//  ChatRoomViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/13/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class ChatRoomViewController: RxBaseViewController {
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<Section, AnyHashable>
    
    enum Section: Int {
        case chat
    }
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.backgroundColor = .yellow
        return view
    }()
    
    private let messageInputField: ChatMessageInputField = {
        let view = ChatMessageInputField()
        return view
    }()
    
    private var messageInputFieldBottomConstraint: Constraint?
    
    private var dataSource: DataSourceType!
    
    override func setupView() {
        setupCollectionView()
    }
    
    override func setupSubviews() {
        view.addSubviews([
            collectionView,
            messageInputField
        ])
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(messageInputField.snp.top)
        }
        
        messageInputField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            messageInputFieldBottomConstraint = make.bottom.equalToSuperview().constraint
        }
    }
    
    override func bind() {
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .subscribe(with: self, onNext: { owner, notification in
                owner.handleKeyboardWillShow(notification: notification)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .subscribe(with: self, onNext: { owner, notification in
                owner.handleKeyboardWillHide(notification: notification)
            })
            .disposed(by: disposeBag)
    }
}

extension ChatRoomViewController {
    
    func setupCollectionView() {
        // 1) Compositional Layout 설정
        configureCompositionalLayout()
        
        // 2) 셀 등록
        registerCollectionViewCells()
        
        // 3) DiffableDataSource 설정
        configureDiffableDataSource()
    }
    
    func configureCompositionalLayout() {
        
    }
    
    func registerCollectionViewCells() {
        
    }
    
    func configureDiffableDataSource() {
        
    }
}

// MARK: - Keyboard Handling

extension ChatRoomViewController {
    
    private func handleKeyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        // 키보드 전체 높이
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        // Safe Area 하단 영역 높이
        let safeAreaBottom = view.safeAreaInsets.bottom
        
        // 기존에 이미 하단 Safe Area 영역만큼 spacing을 줬으니, 키보드 높이만큼만 offset 이동
        // (Safe Area 영역을 직접 계산하지 않고 ChatMessageInputField에서 textView 하단 레이아웃 설정 값(34)으로 해도 OK)
        // + 키보드와 InputField 사이의 간격 5 설정
        let adjustedHeight = keyboardHeight - safeAreaBottom + 5
        
        messageInputFieldBottomConstraint?.update(offset: -adjustedHeight)
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func handleKeyboardWillHide(notification: Notification) {
        guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        messageInputFieldBottomConstraint?.update(offset: 0)
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: ChatRoomViewController())
}
#endif
