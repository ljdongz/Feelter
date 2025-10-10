//
//  ChatRoomListViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/13/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class ChatRoomViewController: RxBaseViewController {
    
    typealias DataSourceType = UITableViewDiffableDataSource<Int, ChatRoom>

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 80
        view.delegate = self
        view.contentInset.top = 20
        return view
    }()
    
    private var dataSource: DataSourceType!

    private let viewModel = ChatRoomViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        showTabBar()
    }
    
    override func setupView() {
        title = "Chat"
        view.backgroundColor = .gray100
        
        setupTableView()
    }
  
    override func setupSubviews() {
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func bind() {
        let viewDidLoadTrigger = PublishRelay<Void>()

        let input = ChatRoomViewModel.Input(
            viewDidLoad: viewDidLoadTrigger.asObservable(),
            receivedAPNs: NotificationCenter.default.rx
                .notification(.ReceiveRemotePush)
                .compactMap { $0.object as? APNsPayload }
                .asObservable(),
            receiveSocketMessage: NotificationCenter.default.rx
                .notification(.ReceiveSocketMessage)
                .map { _ in }
                .asObservable()
        )

        let output = viewModel.transform(input: input)

        output.chatRooms
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, rooms in
                owner.updateDataSource(with: rooms)
            })
            .disposed(by: disposeBag)

        // 모든 구독 연결 후 viewDidLoad 트리거
        viewDidLoadTrigger.accept(())
        
        tableView.rx.itemSelected
            .compactMap { [weak self] indexPath in
                self?.dataSource.itemIdentifier(for: indexPath)
            }
            .subscribe(with: self) { owner, room in
                let viewModel = ChatViewModel(roomID: room.roomID)
                let vc = ChatViewController(viewModel: viewModel)
                
                let userID = owner.viewModel.userID
                let opponent = room.participants.first(where: { $0.userID != userID })
                vc.title = opponent?.nickname
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView Configuration

extension ChatRoomViewController {
    
    private func setupTableView() {
        
        // 1) 셀 등록
        registerTableViewCells()
        
        // 2) DiffableDataSource 설정
        configureDiffableDataSource()
    }
    
    private func registerTableViewCells() {
        tableView.register(
            ChatRoomTableViewCell.self,
            forCellReuseIdentifier: ChatRoomTableViewCell.identifier
        )
    }
    
    private func configureDiffableDataSource() {
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, room in
                guard let self,
                      let cell = tableView.dequeueReusableCell(
                        withIdentifier: ChatRoomTableViewCell.identifier,
                        for: indexPath
                      ) as? ChatRoomTableViewCell else { return .init() }
                
                let userID = viewModel.userID
                guard let opponent = room.participants.first(where: {
                    $0.userID != userID
                }) else { return .init() }
                
                cell.configureCell(.init(
                    profileImageURL: opponent.profileImageURL,
                    name: opponent.nickname,
                    message: room.lastMessage ?? "",
                    date: room.localUpdatedAt,
                    unreadCount: room.unReadCount
                ))
                return cell
            }
        )
    }
}

// MARK: - Update DataSource

extension ChatRoomViewController {
    private func updateDataSource(with newRooms: [ChatRoom]) {
        
        // 새로운 스냅샷을 직접 생성 (DiffableDataSource가 차이점을 자동 계산)
        var newSnapShot = NSDiffableDataSourceSnapshot<Int, ChatRoom>()
        newSnapShot.appendSections([0])
        newSnapShot.appendItems(newRooms)
        
        let isAnimating = dataSource.snapshot().numberOfItems != 0
        
        // DiffableDataSource가 기존 데이터와 새 데이터를 비교해서
        // 실제로 변경된 부분만 애니메이션과 함께 업데이트
        dataSource.apply(newSnapShot, animatingDifferences: isAnimating)
    }
}

// MARK: - TableViewDelegate

extension ChatRoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChatRoomTableViewCell else { return }
        
        cell.animateTouchDown()
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChatRoomTableViewCell else { return }
        
        cell.animateTouchUp()
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: ChatRoomViewController())
}
#endif
