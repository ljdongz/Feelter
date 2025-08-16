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

final class ChatViewController: RxBaseViewController {
    
    typealias DataSourceType = UITableViewDiffableDataSource<Int, AnyHashable>
    
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
    
    private let viewModel: ChatViewModel
    
    private var messageInputFieldBottomConstraint: Constraint?
    private var dataSource: DataSourceType!
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        setupTableView()
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
        let input = ChatViewModel.Input(
            viewDidLoad: .just(()),
            sendMessageButtonTapped: messageInputField.sendButton.rx
                .tap
                .compactMap { [weak self] _ in
                    self?.messageInputField.message
                }
                .do(onNext: { [weak self] _ in
                    self?.messageInputField.message = ""
                })
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.messages
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, updateType in
                switch updateType {
                case .fullReload(let messages):
                    owner.initializeDataSource(messages)
                case .prepend(let messages):
                    owner.prependDataSource(messages)
                case .append(let message):
                    owner.appendDataSource(message)
                }
            }
            .disposed(by: disposeBag)
        
        
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

// MARK: - TableView Configuration

extension ChatViewController {
    
    private func setupTableView() {
        
        // 1) 셀 등록
        registerTableViewCells()
        
        // 2) DiffableDataSource 설정
        configureDiffableDataSource()
    }
    
    private func registerTableViewCells() {
        
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
    
    private func configureDiffableDataSource() {
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
                case .message(let messageItem):
                    if messageItem.sender.isMe {
                        guard let cell = tableView.dequeueReusableCell(
                            withIdentifier: MyMessageTableViewCell.identifier,
                            for: indexPath
                        ) as? MyMessageTableViewCell else {
                            return UITableViewCell()
                        }
                        
                        cell.configureCell(message: messageItem)
                        return cell
                    } else {
                        guard let cell = tableView.dequeueReusableCell(
                            withIdentifier: OtherMessageTableViewCell.identifier,
                            for: indexPath
                        ) as? OtherMessageTableViewCell else {
                            return UITableViewCell()
                        }
                        
                        cell.configureCell(message: messageItem)
                        return cell
                    }
                }
            }
        )
    }
}

// MARK: - Update DataSource
extension ChatViewController {
    private func initializeDataSource(_ messages: [MessageCellType]) {
        var snapShot = dataSource.snapshot()
        snapShot.appendSections([0])
        
        snapShot.appendItems(messages)
        dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    private func prependDataSource(_ messages: [MessageCellType]) {
        
    }
    
    private func appendDataSource(_ message: MessageCellType) {
        
    }
}


// MARK: - Keyboard Handling

extension ChatViewController {
    
    private func handleKeyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.keyboardFrameEndUserInfoKey,
              let animationDuration = notification.keyboardAnimationDurationUserInfoKey else {
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
        guard let animationDuration = notification.keyboardAnimationDurationUserInfoKey,
              let keyboardFrame = notification.keyboardFrameEndUserInfoKey else {
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

extension ChatViewController: UITableViewDelegate {
    
}

extension ChatViewController {
    
    
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(
        rootViewController: ChatViewController(
            viewModel: ChatViewModel(roomID: "")
        )
    )
}
#endif
