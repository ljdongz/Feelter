//
//  MyPageView.swift
//  Feelter
//
//  Created by 이정동 on 8/22/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class MyPageView: RxBaseView {

    typealias DataSourceType = UICollectionViewDiffableDataSource<Section, AnyHashable>
    
    enum Section: Int {
        case mainProfile
        case signOut
        case withdrawal
    }
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        return view
    }()
    
    private var dataSource: DataSourceType!
    
    let chatRoomButtonTapTrigger = PublishRelay<Void>()
    
    override func setupView() {
        setupCollectionView()
    }

    override func setupSubviews() {
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

// MARK: - Public Method

extension MyPageView {
    func applyDataSource(profile: Profile) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        snapShot.appendSections([.mainProfile, .signOut, .withdrawal])
        
        let mainProfile = MainProfileCellItem(
            profileImageURL: profile.profileImageURL ?? "",
            nickname: profile.nickname,
            name: profile.name,
            email: profile.email ?? ""
        )
        snapShot.appendItems([mainProfile], toSection: .mainProfile)
        snapShot.appendItems([UUID().uuidString], toSection: .signOut)
        snapShot.appendItems([UUID().uuidString], toSection: .withdrawal)
        
        dataSource.apply(snapShot, animatingDifferences: false)
    }
}

// MARK: - CollectionView Configuration

extension MyPageView {
    private func setupCollectionView() {
        // 1) Compositional Layout 설정
        configureCompositionalLayout()
        
        // 2) 셀 등록
        registerCollectionViewCells()
        
        // 3) DiffableDataSource 설정
        configureDiffableDataSource()
    }
    
    private func configureCompositionalLayout() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch Section(rawValue: sectionIndex)! {
            case .mainProfile:
                return MainProfileCollectionViewCell.layoutSection()
            case .signOut:
                return SignOutCollectionViewCell.layoutSection()
            case .withdrawal:
                return WithdrawalCollectionViewCell.layoutSection()
            }
        }
        
        collectionView.collectionViewLayout = layout
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(
            MainProfileCollectionViewCell.self,
            forCellWithReuseIdentifier: MainProfileCollectionViewCell.identifier
        )
        
        collectionView.register(
            SignOutCollectionViewCell.self,
            forCellWithReuseIdentifier: SignOutCollectionViewCell.identifier
        )
        
        collectionView.register(
            WithdrawalCollectionViewCell.self,
            forCellWithReuseIdentifier: WithdrawalCollectionViewCell.identifier
        )
    }
    
    private func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                guard let self else { return .init() }
                
                switch Section(rawValue: indexPath.section)! {
                case .mainProfile:
                    guard let item = itemIdentifier as? MainProfileCellItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: MainProfileCollectionViewCell.identifier,
                            for: indexPath
                          ) as? MainProfileCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(item: item)
                    cell.chatRoomsContainerView.rx
                        .tap
                        .bind(to: self.chatRoomButtonTapTrigger)
                        .disposed(by: cell.disposeBag)
                    
                    return cell
                    
                case .signOut:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: SignOutCollectionViewCell.identifier,
                        for: indexPath
                    ) as? SignOutCollectionViewCell else {
                        return .init()
                    }
                    return cell
                
                case .withdrawal:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: WithdrawalCollectionViewCell.identifier,
                        for: indexPath
                    ) as? WithdrawalCollectionViewCell else {
                        return .init()
                    }
                    return cell
                }
            }
        )
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            return nil
        }
    }
}
