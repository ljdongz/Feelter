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
    
    enum Section: Int {
        case chat
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
        snapShot.appendItems(Self.dummyData)
        dataSource.apply(snapShot, animatingDifferences: false)
        
        DispatchQueue.main.async {
            let lastIndexPath = IndexPath(
                row: Self.dummyData.count - 1,
                section: Section.chat.rawValue
            )
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
        
        tableView.register(
            OtherMessageTableViewCell.self,
            forCellReuseIdentifier: OtherMessageTableViewCell.identifier
        )
        
        tableView.register(
            DateSeparatorTableViewCell.self,
            forCellReuseIdentifier: DateSeparatorTableViewCell.identifier
        )
    }
    
    func configureDiffableDataSource() {
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                guard let item = itemIdentifier as? MessageCellType else { return .init() }
                
                switch item {
                
                // 날짜 구분선
                case .dateSeparator(let date):
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: DateSeparatorTableViewCell.identifier,
                        for: indexPath
                    ) as? DateSeparatorTableViewCell else { return .init() }
                    
                    cell.configureCell(date)
                    return cell
                    
                // 메시지
                case .message(let messageData):
                    if messageData.isMe {
                        guard let cell = tableView.dequeueReusableCell(
                            withIdentifier: MyMessageTableViewCell.identifier,
                            for: indexPath
                        ) as? MyMessageTableViewCell else {
                            return UITableViewCell()
                        }
                        cell.configureCell(content: messageData.content, date: messageData.timestamp)
                        return cell
                    } else {
                        guard let cell = tableView.dequeueReusableCell(
                            withIdentifier: OtherMessageTableViewCell.identifier,
                            for: indexPath
                        ) as? OtherMessageTableViewCell else {
                            return UITableViewCell()
                        }
                        cell.configureCell(content: messageData.content, date: messageData.timestamp)
                        return cell
                    }
                }
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

extension ChatRoomViewController {
    
    enum MessageCellType: Hashable {
        case message(MessageItem)
        case dateSeparator(String)
    }
    
    struct MessageItem: Hashable {
        let id = UUID()
        let sender: MessageSender
        let content: String
        let timestamp: String
        
        enum MessageSender: Hashable {
            case me
            case other(name: String, profileImage: String?)
        }
        
        var isMe: Bool {
            switch sender {
            case .me:
                return true
            case .other:
                return false
            }
        }
    }
    
    static let dummyData: [MessageCellType] = [
        .dateSeparator("2025년 8월 14일"),
        .message(MessageItem(
            sender: .other(name: "윤새싹", profileImage: nil),
            content: "안녕하세요!",
            timestamp: "오후 1:15"
        )),
        .message(MessageItem(
            sender: .me,
            content: "네, 안녕하세요",
            timestamp: "오후 1:16"
        )),
        .message(MessageItem(
            sender: .other(name: "윤새싹", profileImage: nil),
            content: "오늘 날씨 정말 좋네요",
            timestamp: "오후 1:17"
        )),
        .message(MessageItem(
            sender: .me,
            content: "네, 정말 좋은 날씨입니다",
            timestamp: "오후 1:18"
        ))
    ]
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: ChatRoomViewController())
}
#endif
