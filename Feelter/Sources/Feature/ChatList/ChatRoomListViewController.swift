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

final class ChatRoomListViewController: RxBaseViewController {
    
    typealias DataSourceType = UITableViewDiffableDataSource<Int, ChatRoom>

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 80
        view.delegate = self
        view.contentInset.top = 20
        return view
    }()
    
    private var dataSource: DataSourceType!

    private let viewModel = ChatRoomListViewModel()
    
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
        let input = ChatRoomListViewModel.Input(
            viewDidLoad: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.chatRooms
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, rooms in
                owner.updateDataSource(with: rooms)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { output.chatRooms.value[$0.row] }
            .subscribe(with: self) { owner, room in
                let viewModel = ChatRoomViewModel(roomID: room.roomID)
                let vc = ChatRoomViewController(viewModel: viewModel)
                vc.title = room.participants.last?.nickname
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView Configuration

extension ChatRoomListViewController {
    
    private func setupTableView() {
        
        // 1) 셀 등록
        registerTableViewCells()
        
        // 2) DiffableDataSource 설정
        configureDiffableDataSource()
    }
    
    private func registerTableViewCells() {
        tableView.register(
            ChatRoomListTableViewCell.self,
            forCellReuseIdentifier: ChatRoomListTableViewCell.identifier
        )
    }
    
    private func configureDiffableDataSource() {
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, room in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ChatRoomListTableViewCell.identifier,
                    for: indexPath
                ) as? ChatRoomListTableViewCell else { return .init() }
                
                guard let profile = room.participants.last else { return .init() }
                
                cell.configureCell(.init(
                    profileImageURL: profile.profileImageURL,
                    name: profile.nickname,
                    message: room.lastChat?.content ?? "",
                    date: room.updatedAt.formatted(.basic),
                    unreadCount: 0
                ))
                return cell
            }
        )
    }
}

// MARK: - Update DataSource

extension ChatRoomListViewController {
    private func updateDataSource(with newRooms: [ChatRoom]) {
        // 새로운 스냅샷을 직접 생성 (DiffableDataSource가 차이점을 자동 계산)
        var newSnapShot = NSDiffableDataSourceSnapshot<Int, ChatRoom>()
        newSnapShot.appendSections([0])
        newSnapShot.appendItems(newRooms.sorted { $0.updatedAt > $1.updatedAt })
        
        // DiffableDataSource가 기존 데이터와 새 데이터를 비교해서
        // 실제로 변경된 부분만 애니메이션과 함께 업데이트
        dataSource.apply(newSnapShot, animatingDifferences: true)
    }
}

// MARK: - TableViewDelegate

extension ChatRoomListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChatRoomListTableViewCell else { return }
        
        cell.animateTouchDown()
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChatRoomListTableViewCell else { return }
        
        cell.animateTouchUp()
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: ChatRoomListViewController())
}
#endif
