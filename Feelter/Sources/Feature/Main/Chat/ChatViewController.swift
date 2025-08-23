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
        view.contentInset.bottom = 20
        view.estimatedRowHeight = 100
        return view
    }()
    
    private let messageInputField: ChatMessageInputField = {
        let view = ChatMessageInputField()
        return view
    }()
    
    private let dateSeparatorGenerator = DateSeparatorGenerator()
    private let viewModel: ChatViewModel
    
    private var messageInputFieldBottomConstraint: Constraint?
    private var dataSource: DataSourceType!
    
    private var didInitDataSource = false
    private var isLoadingMoreMessages = false
    private var isFullLoadMessage = false
    
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
                    self?.messageInputField.message
                }
                .do(onNext: { [weak self] _ in
                    self?.messageInputField.message = ""
                })
                .asObservable(),
            loadMoreMessages: tableView.rx.contentOffset
                .filter { [weak self] _ in
                    guard let self else { return false }
                    return self.didInitDataSource && !self.isLoadingMoreMessages && !isFullLoadMessage
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
                case .fullReload(let messages):
                    owner.initializeDataSource(messages)
                case .prepend(let messages):
                    owner.prependDataSource(messages)
                case .append(let messages):
                    owner.appendDataSource(messages)
                }
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
                    
                    cell.configureCell(date.date)
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
    private func initializeDataSource(_ messages: [ChatMessage]) {
        let cellTypes = dateSeparatorGenerator.generateCellTypes(
            from: messages,
            currentUserID: viewModel.userID
        )
        
        var snapShot = dataSource.snapshot()
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
    
    private func prependDataSource(_ messages: [ChatMessage]) {
        if messages.isEmpty {
            isFullLoadMessage = true
            return
        }
        
        let cellTypes = dateSeparatorGenerator.generateCellTypes(
            from: messages,
            currentUserID: viewModel.userID
        )
        
        // 현재 첫 번째 가시 셀의 IndexPath 저장
        let firstVisibleIndexPath = tableView.indexPathsForVisibleRows?.first
        
        // 기존 아이템들 가져오기
        let currentItems = dataSource.snapshot().itemIdentifiers
        
        // 새로운 스냅샷 생성
        var newSnapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
        newSnapshot.appendSections([0])
        
        // 새 메시지 + 기존 메시지 순서로 추가
        let newItems = cellTypes.map { $0 as AnyHashable }
        newSnapshot.appendItems(newItems + currentItems)
        
        // 스냅샷 적용
        dataSource.apply(newSnapshot, animatingDifferences: false)
        
        // 레이아웃 강제 업데이트
        tableView.layoutIfNeeded()
        
        // 스크롤 위치 복원
        if let firstVisibleIndexPath = firstVisibleIndexPath {
            let newIndexPath = IndexPath(
                row: firstVisibleIndexPath.row + cellTypes.count,
                section: firstVisibleIndexPath.section
            )
            
            // 복원된 위치로 스크롤 (애니메이션 없이)
            tableView.scrollToRow(at: newIndexPath, at: .top, animated: false)
        }
        
        // 로딩 상태 해제
        isLoadingMoreMessages = false
    }
    
    private func appendDataSource(_ messages: [ChatMessage]) {
        var cellTypes = dateSeparatorGenerator.generateCellTypes(
            from: messages,
            currentUserID: viewModel.userID
        )
        
        var snapShot = dataSource.snapshot()
        
        // 현재 DataSource에 반영된 마지막 채팅 데이터 날짜와 비교해서 구분선 중복 제거
        // TODO: 마지막 채팅 메시지와 비교해서 프로필, 날짜 표시 여부 수정
        if let items = snapShot.itemIdentifiers as? [MessageCellType],
           let lastItem = items.last,
           case let MessageCellType.message(prevMessage) = lastItem {
            
            let prevTimeStamp = prevMessage.timestamp.formatted(.fullDateWithWeekday)
            let currentTimeStamp = messages.first?.createdAt.formatted(.fullDateWithWeekday)
            if prevTimeStamp == currentTimeStamp {
                cellTypes.removeFirst()
            }
        }
            
        snapShot.appendItems(cellTypes)
        dataSource.apply(snapShot, animatingDifferences: false)
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

extension ChatViewController: UITableViewDelegate { }



