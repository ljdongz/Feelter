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
    
    typealias DataSourceType = UITableViewDiffableDataSource<Section, AnyHashable>
    
    enum Section {
        case chat
    }
    
    struct MessageItem: Hashable {
        let id = UUID()
        let content: String
        let date: String
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.delegate = self
        view.contentInset.top = 20
        view.estimatedRowHeight = 100
        return view
    }()
    
    private let messageInputField: ChatMessageInputField = {
        let view = ChatMessageInputField()
        return view
    }()
    
    private var messageInputFieldBottomConstraint: Constraint?
    
    private var dataSource: DataSourceType!
    
    override func setupView() {
        setupTableView()
        
        loadInitialData()
    }

    private func loadInitialData() {
        
        var snapShot = dataSource.snapshot()
        snapShot.appendSections([.chat])
        snapShot.appendItems(MessageItem.dummy)
        dataSource.apply(snapShot, animatingDifferences: false)
        
        DispatchQueue.main.async {
            let lastIndexPath = IndexPath(row: MessageItem.dummy.count - 1, section: 0)
            self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
        }
    }
    
    override func setupSubviews() {
        view.addSubviews([
            tableView,
            messageInputField
        ])
    }
    
    override func setupConstraints() {
        messageInputField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            messageInputFieldBottomConstraint = make.bottom.equalToSuperview().constraint
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(messageInputField.snp.top)
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
    
    func setupTableView() {
        
        // 1) 셀 등록
        registerTableViewCells()
        
        // 2) DiffableDataSource 설정
        configureDiffableDataSource()
    }
    
    func registerTableViewCells() {
        tableView.register(
            MyMessageTableViewCell.self,
            forCellReuseIdentifier: MyMessageTableViewCell.identifier
        )
    }
    
    func configureDiffableDataSource() {
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                guard let item = itemIdentifier as? MessageItem,
                      let cell = tableView.dequeueReusableCell(
                        withIdentifier: MyMessageTableViewCell.identifier,
                        for: indexPath
                      ) as? MyMessageTableViewCell else {
                    return UITableViewCell()
                }
                cell.configureCell(content: item.content, date: item.date)
                return cell
            }
        )
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
        
        var newContentOffset = tableView.contentOffset
        newContentOffset.y = max(0, newContentOffset.y + adjustedHeight)
        
        tableView.contentOffset = newContentOffset
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func handleKeyboardWillHide(notification: Notification) {
        guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let safeAreaBottom = view.safeAreaInsets.bottom
        let adjustedHeight = keyboardHeight - safeAreaBottom + 5
        
        messageInputFieldBottomConstraint?.update(offset: 0)
        
        // TODO: 수정 필요
        var newContentOffset = self.tableView.contentOffset
        newContentOffset.y = max(0, newContentOffset.y - adjustedHeight)
        tableView.contentOffset = newContentOffset
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatRoomViewController: UITableViewDelegate {
    
}

extension ChatRoomViewController.MessageItem {
    static let dummy = [
        ChatRoomViewController.MessageItem(content: "asdfas1f", date: "오후 1:15"),
        ChatRoomViewController.MessageItem(content: "asdf321asfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasf", date: "오후 1:15"),
        ChatRoomViewController.MessageItem(content: "a131313131313131313131313131313sdf3asf", date: "오후 1:15"),
        ChatRoomViewController.MessageItem(content: "asasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfdf43asf", date: "오후 1:15"),
        ChatRoomViewController.MessageItem(content: "asd43asdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasf5fasf", date: "오후 1:15"),
        ChatRoomViewController.MessageItem(content: "a1543sdfasf", date: "오후 1:15"),
        ChatRoomViewController.MessageItem(content: "asdfaasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfsf", date: "오후 1:15"),
        ChatRoomViewController.MessageItem(content: "afㅁㄴㅇㄹ\nasdfasfasdfasf", date: "오후 1:15"),
        ChatRoomViewController.MessageItem(content: "af", date: "오후 1:15"),
        ChatRoomViewController.MessageItem(content: "asdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasf", date: "오후 1:15"),
        ChatRoomViewController.MessageItem(content: "asdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasfasdfasf", date: "오후 1:15"),
    ]
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: ChatRoomViewController())
}
#endif
