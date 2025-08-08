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
        case category
        case topRanking
        case feed
    }
    
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
    
    private var categoryItems: [CategorySectionItem] = CategorySectionItem.default
    
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
extension FilterFeedView {
    
    func applyFeedSnapShot() {
        var snapShot = dataSource.snapshot(for: .topRanking)
        snapShot.append(["123", "43", "13", "5353"])
        dataSource.apply(snapShot, to: .topRanking)

        var feedSnapShot = dataSource.snapshot(for: .feed)
        feedSnapShot.append(["aasdf", "fdasfsad", "asdfas", "fds", "vddas", "fadsfsf"])
        dataSource.apply(feedSnapShot, to: .feed)
    }
    
    func updateCategorySelection(selectedIndexPath: IndexPath) {
        guard selectedIndexPath.section == Section.category.rawValue else { return }
        
        // 데이터 모델 업데이트
        categoryItems = categoryItems.enumerated().map { index, item in
            CategorySectionItem(
                category: item.category,
                isSelected: index == selectedIndexPath.item
            )
        }
        
        // 스냅샷 업데이트
        var snapshot = dataSource.snapshot(for: .category)
        snapshot.deleteAll()
        snapshot.append(categoryItems)
        dataSource.apply(snapshot, to: .category, animatingDifferences: false)
    }
}

// MARK: - Private Method

private extension FilterFeedView {
    func applyInitialDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.category])
        snapshot.appendItems(categoryItems, toSection: .category)
        dataSource.apply(snapshot)
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
        
        // 4) 초기 데이터 설정
        applyInitialDataSource()

        // TODO: 삭제하기
        applyFeedSnapShot()
    }
    
    func configureCompositionalLayout() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch Section(rawValue: sectionIndex) {
            case .category:
                return FilterCategoryCollectionViewCell.layoutSection()
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
        
        // 푸터 뷰
        collectionView.register(
            FilterCategoryFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FilterCategoryFooterView.identifier
        )
        
        collectionView.register(
            FilterCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: FilterCategoryCollectionViewCell.identifier
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
                case .category:
                    guard let item = itemIdentifier as? CategorySectionItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: FilterCategoryCollectionViewCell.identifier,
                            for: indexPath
                          ) as? FilterCategoryCollectionViewCell else { return .init() }
                    
                    cell.configureCell(item: item)
                    return cell
                    
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
            
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
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
            } else if kind == UICollectionView.elementKindSectionFooter {
                guard let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: FilterCategoryFooterView.identifier,
                    for: indexPath
                ) as? FilterCategoryFooterView else { return nil }
                
                return footerView
            } else {
                return nil
            }
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
