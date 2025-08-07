//
//  FilterFeedView.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import UIKit

import SnapKit

final class FilterFeedView: BaseView {
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<Section, AnyHashable>

    enum Section: Int {
        case topRanking
        case feed
    }
        
    private let categoryButtonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    let categoryButtonView: CategoryButtonView = {
        let view = CategoryButtonView()
        return view
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray90.withAlphaComponent(0.5)
        return view
    }()
    
    let collectionView: UICollectionView = {
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
    
    override func setupView() {
        setupCollectionView()
    }

    override func setupSubviews() {
        addSubviews([
            categoryButtonContainerView,
            divider,
            collectionView
        ])
        
        categoryButtonContainerView.addSubview(categoryButtonView)
    }
    
    override func setupConstraints() {
        categoryButtonContainerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
        
        categoryButtonView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(categoryButtonContainerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        // TODO: 삭제하기
        applyFeedSnapShot()
    }
    
    func applyFeedSnapShot() {
        var snapShot = dataSource.snapshot(for: .topRanking)
        snapShot.append(["123", "43", "13", "5353"])
        dataSource.apply(snapShot, to: .topRanking)
        
        var feedSnapShot = dataSource.snapshot(for: .feed)
        feedSnapShot.append(["aasdf", "fdasfsad", "asdfas", "fds", "vddas", "fadsfsf"])
        dataSource.apply(feedSnapShot, to: .feed)
    }
}

// MARK: - CollectionView Configuration

private extension FilterFeedView {
    func setupCollectionView() {
        // 1) Compositional Layout 설정
        configureCompositionalLayout()
        
        // 2) 셀 등록
        registerCollectionViewCells()
        
        // 3) DiffableDataSource 설정
        configureDiffableDataSource()
    }
    
    func configureCompositionalLayout() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch Section(rawValue: sectionIndex) {
            case .topRanking:
                return TopRankingFeedCollectionViewCell.layoutSection()
            case .feed:
                return FilterFeedListCollectionViewCell.layoutSection()
            default:
                return TopRankingFeedCollectionViewCell.layoutSection()
            }
        }
        
        collectionView.collectionViewLayout = layout
    }
    
    func registerCollectionViewCells() {
        
        // 헤더 뷰
        collectionView.register(
            BaseSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BaseSectionHeaderView.identifier
        )
        
        // Top Ranking
        collectionView.register(
            TopRankingFeedCollectionViewCell.self,
            forCellWithReuseIdentifier: TopRankingFeedCollectionViewCell.identifier
        )
        
        // Feed
        collectionView.register(
            FilterFeedListCollectionViewCell.self,
            forCellWithReuseIdentifier: FilterFeedListCollectionViewCell.identifier
        )
        
    }
    
    func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                
                switch Section(rawValue: indexPath.section) {
                case .topRanking:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TopRankingFeedCollectionViewCell.identifier,
                            for: indexPath
                          ) as? TopRankingFeedCollectionViewCell else { return .init() }
                    
                    cell.configureCell()
                    return cell
                case .feed:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: FilterFeedListCollectionViewCell.identifier,
                            for: indexPath
                          ) as? FilterFeedListCollectionViewCell else { return .init() }
                    
                    cell.configureCell()
                    return cell
                default:
                    return .init()
                }
            }
        )
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: BaseSectionHeaderView.identifier,
                    for: indexPath
                  ) as? BaseSectionHeaderView else { return nil }
            
            let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .topRanking:
                headerView.configure(leading: "Top Ranking")
            case .feed:
                headerView.configure(leading: "Filter Feed", trailing: "List Mode")
            default:
                break
            }
            
            return headerView
        }
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: FilterFeedViewController())
}
#endif
