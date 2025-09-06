//
//  ChatRoomViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/13/25.
//

import PhotosUI
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
        view.contentInset.bottom = 20
        view.estimatedRowHeight = 100
        return view
    }()
    
    private var messageInputField: ChatMessageInputFieldView = {
        let view = ChatMessageInputFieldView()
        return view
    }()
    
    private let messageCellGenerator = ChatMessageCellGenerator()
    private let viewModel: ChatViewModel
    
    private var messageInputFieldBottomConstraint: Constraint?
    private var dataSource: DataSourceType!
    
    private var didInitDataSource = false
    private var isLoadingMoreMessages = false
    private var isFullLoadMessage = false
    
    private(set) var isKeyboardShown: Bool = false
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        showTabBar()
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
            viewWillDisappear: rx.viewWillDisappear.asObservable(),
            sendMessageButtonTapped: messageInputField.sendButton.rx
                .tap
                .compactMap { [weak self] _ in
                    self?.messageInputField.messageField.content
                }
                .do(onNext: { [weak self] _ in
                    self?.messageInputField.sendButtonTapped()
                })
                .asObservable(),
            loadMoreMessages: tableView.rx.contentOffset
                .filter { [weak self] _ in
                    guard let self else { return false }
                    return self.didInitDataSource && !self.isLoadingMoreMessages && !self.isFullLoadMessage
                }
                .map { [weak self] offset in
                    guard let self else { return false }
                    let offsetY = offset.y
                    let contentHeight = self.tableView.contentSize.height
                    let frameHeight = self.tableView.frame.height
                    return offsetY <= 50 && contentHeight > frameHeight
                }
                .distinctUntilChanged()
                .filter { $0 }
                .do(onNext: { [weak self] _ in
                    self?.isLoadingMoreMessages = true
                })
                .map { _ in () }
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.messages
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, updateType in
                switch updateType {
                case .initMessages(let messages):
                    owner.initializeDataSourceItems(messages)
                    
                case .prependPastMessages(let messages):
                    owner.prependDataSourceItems(messages)
                    
                case .appendUnReadMessages(let messages):
                    owner.appendDataSourceItems(messages)
                    
                case .appendNewMessage(let message):
                    owner.appendDataSourceItem(message)
                }
            }
            .disposed(by: disposeBag)
        
        messageInputField.plusButton.rx
            .tap
            .filter { [weak self] _ in
                self?.messageInputField.messageField.files.count != 5
            }
            .subscribe(with: self) { owner, _ in
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 5 - owner.messageInputField.messageField.files.count
                configuration.filter = .images
                
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                owner.view.endEditing(true)
                owner.present(picker, animated: true)
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.KeyboardWillShow)
            .subscribe(with: self, onNext: { owner, notification in
                owner.handleKeyboardWillShow(notification: notification)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.KeyboardWillHide)
            .subscribe(with: self, onNext: { owner, notification in
                owner.handleKeyboardWillHide(notification: notification)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
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
            MessageSeparatorTableViewCell.self,
            forCellReuseIdentifier: MessageSeparatorTableViewCell.identifier
        )
    }
    
    private func configureDiffableDataSource() {
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                guard let item = itemIdentifier as? MessageCellType else { return .init() }
                
                switch item {
                
                // 날짜 구분선
                case .separator(let separator):
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: MessageSeparatorTableViewCell.identifier,
                        for: indexPath
                    ) as? MessageSeparatorTableViewCell else { return .init() }
                    
                    cell.configureCell(separator.text)
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
    private func initializeDataSourceItems(_ messages: [ChatMessage]) {
        let cellTypes = messageCellGenerator.generateCellTypes(
            from: messages,
            currentUserID: viewModel.userID,
            insertPosition: .standard
        )
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
        snapShot.appendSections([0])
        
        snapShot.appendItems(cellTypes)
        dataSource.apply(snapShot, animatingDifferences: false)
        
        guard !cellTypes.isEmpty else { return }
        tableView.scrollToRow(
            at: IndexPath(row: cellTypes.count - 1, section: 0),
            at: .bottom,
            animated: false
        )
        
        didInitDataSource = true
    }
    
    private func prependDataSourceItems(_ messages: [ChatMessage]) {
        if messages.isEmpty {
            isFullLoadMessage = true
            return
        }
        
        let cellTypes = messageCellGenerator.generateCellTypes(
            from: messages,
            currentUserID: viewModel.userID,
            insertPosition: .prepend
        )
        
        let originItemCount = dataSource.snapshot().itemIdentifiers.count
        // 현재 첫 번째 가시 셀의 IndexPath 저장
        let firstVisibleIndexPath = tableView.indexPathsForVisibleRows?.first
        
        // 새로운 스냅샷 생성
        var newSnapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
        newSnapshot.appendSections([0])
        newSnapshot.appendItems(cellTypes)
        
        // 스냅샷 적용
        dataSource.apply(newSnapshot, animatingDifferences: false)
        
        // 레이아웃 강제 업데이트
        tableView.layoutIfNeeded()
        
        // 스크롤 위치 복원
        if let firstVisibleIndexPath = firstVisibleIndexPath {
            let newIndexPath = IndexPath(
                row: (cellTypes.count - originItemCount) + firstVisibleIndexPath.row,
                section: firstVisibleIndexPath.section
            )
            
            // 복원된 위치로 스크롤 (애니메이션 없이)
            tableView.scrollToRow(at: newIndexPath, at: .top, animated: false)
        }
        
        // 로딩 상태 해제
        isLoadingMoreMessages = false
    }
    
    private func appendDataSourceItems(_ messages: [ChatMessage]) {
        if messages.isEmpty { return }
        
        let cellTypes = messageCellGenerator.generateCellTypes(
            from: messages,
            currentUserID: viewModel.userID,
            insertPosition: .append
        )
        
        var newSnapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
        newSnapshot.appendSections([0])
            
        newSnapshot.appendItems(cellTypes)
        dataSource.apply(newSnapshot, animatingDifferences: false)
    }
    
    private func appendDataSourceItem(_ message: ChatMessage) {
        let cellTypes = messageCellGenerator.generateCellTypes(
            from: [message],
            currentUserID: viewModel.userID,
            insertPosition: .append
        )
        
        let originItemCount = dataSource.snapshot().itemIdentifiers.count
        let lastVisibleCell = tableView.indexPathsForVisibleRows?.last
        
        var newSnapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
        newSnapshot.appendSections([0])
            
        newSnapshot.appendItems(cellTypes)
        dataSource.apply(newSnapshot, animatingDifferences: false)
        
        // 내가 보낸 메시지이거나, 스크롤 위치가 마지막 메시지인 경우, 새 메시지 수신 시 맨 하단으로 스크롤
        if message.sender.userID == viewModel.userID ||
            lastVisibleCell?.row == originItemCount - 1 {
            tableView.scrollToRow(
                at: .init(row: cellTypes.count - 1, section: 0),
                at: .bottom,
                animated: false
            )
        }
    }
}


// MARK: - Keyboard Handling

extension ChatViewController {
    
    private func handleKeyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.keyboardFrameEndUserInfoKey,
              let animationDuration = notification.keyboardAnimationDurationUserInfoKey else {
            return
        }
        
        if isKeyboardShown { return }
        isKeyboardShown = true
        
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
        
        isKeyboardShown = false
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let safeAreaBottom = view.safeAreaInsets.bottom
        let adjustedHeight = keyboardHeight - safeAreaBottom + 5
        
        messageInputFieldBottomConstraint?.update(offset: 0)
        
        var newContentOffset = self.tableView.contentOffset
        newContentOffset.y = max(0, newContentOffset.y - adjustedHeight)
        tableView.contentOffset = newContentOffset
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        dismiss(animated: true)
        
        if results.isEmpty { return }
        
        Task { @MainActor in
            do {
                let images = try await withThrowingTaskGroup(of: (Int, UIImage?).self) { group in
                    for (index, result) in results.enumerated() {
                        group.addTask {
                            let image = try await result.itemProvider.loadUIImage()
                            return (index, image)
                        }
                    }
                    
                    var loadedImages: [(Int, UIImage)] = []
                    for try await result in group {
                        if let image = result.1 {
                            loadedImages.append((result.0, image))
                        }
                    }
                    return loadedImages
                }
                
                let sortedImages = images.sorted { $0.0 < $1.0 }.map { $0.1 }
                messageInputField.appendFiles(sortedImages)
            } catch {
                print("Image loading error: \(error)")
            }
        }
    }
}

extension ChatViewController: UITableViewDelegate { }
