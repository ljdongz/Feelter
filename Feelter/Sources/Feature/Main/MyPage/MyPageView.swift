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
        
        snapShot.appendSections([.mainProfile])
        
        let mainProfile = MainProfileCellItem(
            profileImageURL: profile.profileImageURL ?? "",
            nickname: profile.nickname,
            name: profile.name,
            email: profile.email ?? ""
        )
        snapShot.appendItems([mainProfile], toSection: .mainProfile)
        
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
            switch Section(rawValue: sectionIndex) {
            case .mainProfile:
                return MainProfileCollectionViewCell.layoutSection()
            default:
                return MainProfileCollectionViewCell.layoutSection()
            }
        }
        
        collectionView.collectionViewLayout = layout
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(
            MainProfileCollectionViewCell.self,
            forCellWithReuseIdentifier: MainProfileCollectionViewCell.identifier
        )
        
    }
    
    private func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                guard let self else { return .init() }
                
                switch Section(rawValue: indexPath.section) {
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
                default:
                    return .init()
                }
            }
        )
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            return nil
        }
    }
}
