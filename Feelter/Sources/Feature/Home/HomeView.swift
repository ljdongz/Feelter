//
//  HomeView.swift
//  Feelter
//
//  Created by 이정동 on 8/5/25.
//

import UIKit

import SnapKit

final class HomeView: BaseView {
    
    enum Section: Int {
        case todayFilter
        case hotTrend
        
        case authorHeader
        case authorPhotos
        case authorHashTags
        case authorIntroduction
    }
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<Section, String>
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        return view
    }()
    
    private var dataSource: DataSourceType?
    
    override func setupView() {
        setupCollectionView()
    }

    override func setupSubviews() {
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - CollectionView Setup
private extension HomeView {
    func setupCollectionView() {
        // 1) Compositional Layout 설정
        configureCompositionalLayout()
        
        // 2) 셀 등록
        registerCollectionViewCells()
        
        // 3) DiffableDataSource 설정
        configureDiffableDataSource()
        
        // 4) DiffableDataSource Snapshot 설정
        var snapShot = NSDiffableDataSourceSnapshot<Section, String>()
        
        snapShot.appendSections([.todayFilter])
        snapShot.appendItems(["123"], toSection: .todayFilter)
        
        snapShot.appendSections([.hotTrend])
        snapShot.appendItems(["", "1", "2", "3"], toSection: .hotTrend)
        
        snapShot.appendSections([.authorHeader])
        snapShot.appendItems(["a"], toSection: .authorHeader)
        
        snapShot.appendSections([.authorPhotos])
        snapShot.appendItems(["b", "c", "d"], toSection: .authorPhotos)
        
        snapShot.appendSections([.authorHashTags])
        snapShot.appendItems(["섬세함섬세함", "자연자연", "풍경풍경", "미니멀리즘미니멀리즘", "아르떼아르떼"], toSection: .authorHashTags)
        
        snapShot.appendSections([.authorIntroduction])
        snapShot.appendItems(["ccc"], toSection: .authorIntroduction)
        
        dataSource?.apply(snapShot)
    }
    
    func configureCompositionalLayout() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch Section(rawValue: sectionIndex) {
            case .todayFilter:
                return TodayFilterCollectionViewCell.layoutSection()
            case .hotTrend:
                return HotTrendCollectionViewCell.layoutSection()
            case .authorHeader:
                return TodayAuthorProfileCollectionViewCell.layoutSection()
            case .authorPhotos:
                return TodayAuthorPhotosCollectionViewCell.layoutSection()
            case .authorHashTags:
                return HashTagCollectionViewCell.layoutSection()
            case .authorIntroduction:
                return TodayAuthorIntroductionCollectionViewCell.layoutSection()
            case .none:
                return TodayFilterCollectionViewCell.layoutSection()
            }
        }
        collectionView.collectionViewLayout = layout
    }
    
    func registerCollectionViewCells() {
        // 오늘의 필터
        collectionView.register(
            TodayFilterCollectionViewCell.self,
            forCellWithReuseIdentifier: TodayFilterCollectionViewCell.identifier
        )
        
        // 섹션 헤더 타이틀
        collectionView.register(
            BaseSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BaseSectionHeaderView.identifier
        )
        
        // 핫 트랜드
        collectionView.register(
            HotTrendCollectionViewCell.self,
            forCellWithReuseIdentifier: HotTrendCollectionViewCell.identifier
        )
        
        // 오늘의 작가 프로필
        collectionView.register(
            TodayAuthorProfileCollectionViewCell.self,
            forCellWithReuseIdentifier: TodayAuthorProfileCollectionViewCell.identifier
        )
        
        // 오늘의 작가 사진 목록
        collectionView.register(
            TodayAuthorPhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: TodayAuthorPhotosCollectionViewCell.identifier
        )
        
        // 오늘의 작가 해시태그 목록
        collectionView.register(
            HashTagCollectionViewCell.self,
            forCellWithReuseIdentifier: HashTagCollectionViewCell.identifier
        )
        
        // 오늘의 작가 소개글
        collectionView.register(
            TodayAuthorIntroductionCollectionViewCell.self,
            forCellWithReuseIdentifier: TodayAuthorIntroductionCollectionViewCell.identifier
        )
    }
    
    func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                
                switch Section(rawValue: indexPath.section) {
                case .todayFilter:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TodayFilterCollectionViewCell.identifier,
                            for: indexPath
                          ) as? TodayFilterCollectionViewCell else {
                        
                        return .init()
                    }
                    cell.configureCell()
                    return cell
                    
                case .hotTrend:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: HotTrendCollectionViewCell.identifier,
                            for: indexPath
                          ) as? HotTrendCollectionViewCell else {
                        return .init()
                    }
                    return cell
                    
                case .authorHeader:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TodayAuthorProfileCollectionViewCell.identifier,
                            for: indexPath
                          ) as? TodayAuthorProfileCollectionViewCell else {
                        return .init()
                    }
                    cell.configureCell()
                    return cell
                    
                case .authorPhotos:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TodayAuthorPhotosCollectionViewCell.identifier,
                            for: indexPath
                          ) as? TodayAuthorPhotosCollectionViewCell else {
                        return .init()
                    }
                    cell.configureCell()
                    return cell
                    
                case .authorHashTags:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: HashTagCollectionViewCell.identifier,
                            for: indexPath
                          ) as? HashTagCollectionViewCell else {
                        return .init()
                    }
                    cell.configure(text: item, xmarkIsHidden: true)
                    return cell
                    
                case .authorIntroduction:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TodayAuthorIntroductionCollectionViewCell.identifier,
                            for: indexPath
                          ) as? TodayAuthorIntroductionCollectionViewCell else {
                        return .init()
                    }
                    cell.configureCell(
                        header: "자연의 섬세함을 담아내는 감성 사진작가",
                        body: """
                            윤새싹은 자연의 섬세한 아름다움을 포착하는 데 탁월한 감각을 지닌 사진작가입니다. 그녀의 작품은 일상 속에서 쉽게 지나칠 수 있는 순간들을 특별하게 담아내며, 관람객들에게 새로운 시각을 선사합니다.
                            """
                    )
                    return cell
                    
                case .none:
                    return .init()
                }
            }
        )
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: BaseSectionHeaderView.identifier,
                for: indexPath
            ) as? BaseSectionHeaderView else { return nil }
            
            let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .hotTrend:
                headerView.configure(title: "핫 트렌드")
            case .authorHeader:
                headerView.configure(title: "오늘의 작가 소개")
            default:
                break
            }
            
            return headerView
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}


#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    HomeViewController()
}
#endif
