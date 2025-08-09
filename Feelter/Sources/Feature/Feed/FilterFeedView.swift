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
        case order
        case topRanking
        case feed
    }
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()
    
    private var dataSource: DataSourceType!
    
    private var categoryItems: [CategorySectionItem] = CategorySectionItem.default
    private var orderItems: [OrderSectionItem] = OrderSectionItem.default
    
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
    
    func updateCategorySelection(selectedIndex: Int) {
        // 데이터 모델 업데이트
        categoryItems = categoryItems.enumerated().map { index, item in
            CategorySectionItem(
                category: item.category,
                isSelected: index == selectedIndex
            )
        }
        
        // 스냅샷 업데이트
        var snapshot = dataSource.snapshot(for: .category)
        snapshot.deleteAll()
        snapshot.append(categoryItems)
        dataSource.apply(snapshot, to: .category, animatingDifferences: false)
    }
    
    func updateOrderSelection(selectedIndex: Int) {
        // 데이터 모델 업데이트
        orderItems = orderItems.enumerated().map { index, item in
            OrderSectionItem(
                order: item.order,
                isSelected: index == selectedIndex
            )
        }
        
        // 스냅샷 업데이트
        var snapshot = dataSource.snapshot(for: .order)
        snapshot.deleteAll()
        snapshot.append(orderItems)
        dataSource.apply(snapshot, to: .order, animatingDifferences: false)
    }
}

// MARK: - Private Method

private extension FilterFeedView {
    func applyInitialDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.category, .order])
        snapshot.appendItems(categoryItems, toSection: .category)
        snapshot.appendItems(orderItems, toSection: .order)
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
            case .order:
                return FilterOrderCollectionViewCell.layoutSection()
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
        
        // 카테고리 선택 버튼
        collectionView.register(
            FilterCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: FilterCategoryCollectionViewCell.identifier
        )
        
        // 정렬 상태 선택 버튼
        collectionView.register(
            FilterOrderCollectionViewCell.self,
            forCellWithReuseIdentifier: FilterOrderCollectionViewCell.identifier
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
                    
                case .order:
                    guard let item = itemIdentifier as? OrderSectionItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: FilterOrderCollectionViewCell.identifier,
                            for: indexPath
                          ) as? FilterOrderCollectionViewCell else { return .init() }
                    
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
            } else {
                return nil
            }
        }
    }
}

extension FilterFeedView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        cell.animateTouchDown()
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        cell.animateTouchUp()
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: FilterFeedViewController())
}
#endif
