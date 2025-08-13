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

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 80
        view.separatorStyle = .none
        view.register(
            ChatRoomListTableViewCell.self,
            forCellReuseIdentifier: ChatRoomListTableViewCell.identifier
        )
        view.delegate = self
        view.contentInset.top = 20
        return view
    }()

    private let viewModel = ChatRoomListViewModel()
    
    override func setupView() {
        title = "Chat"
        view.backgroundColor = .gray100
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
            .bind(to: tableView.rx.items(
                cellIdentifier: ChatRoomListTableViewCell.identifier,
                cellType: ChatRoomListTableViewCell.self
            )) { row, element, cell in
                cell.selectionStyle = .none
                cell.configureCell(element)
            }
            .disposed(by: disposeBag)
    }
}

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
