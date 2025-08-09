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
        case banner
        case hotTrend
        case authorHeader
        case authorPhotos
        case authorHashTags
        case authorIntroduction
    }
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<Section, AnyHashable>
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.bounces = false
        return view
    }()
    
    private var dataSource: DataSourceType!
    private var bannerTimer: Timer?
    private var currentBannerPageIndex: Int = 0
    private var bannerCount: Int = 0
    private weak var bannerPageIndicator: BannerPageIndicatorDecorationView?
    
    deinit {
        stopBannerAutoScroll()
    }
    
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

// MARK: - Public Method

extension HomeView {
    func applyTodayFilterSnapShot(_ filter: Filter) {
        var snapShot = dataSource.snapshot(for: .todayFilter)
        snapShot.append([filter])
        dataSource.apply(snapShot, to: .todayFilter)
    }
    
    func applyBannerSnapShot(_ banners: [Banner]) {
        var snapShot = dataSource.snapshot(for: .banner)
        snapShot.append(banners)
        dataSource.apply(snapShot, to: .banner)
        
        currentBannerPageIndex = 0
        bannerCount = banners.count
        
        // 레이아웃 완료 후 DecorationView 캐싱 및 업데이트
        cachingBannerPageIndicatorView()
        bannerPageIndicator?.configureView(total: banners.count)
        startBannerAutoScroll()
    }
    
    func applyHotTrendFiltersSnapShot(_ filters: [Filter]) {
        var snapShot = dataSource.snapshot(for: .hotTrend)
        snapShot.append(filters)
        dataSource.apply(snapShot, to: .hotTrend)
    }
    
    func applyTodayAuthorSnapShot(_ author: TodayAuthor) {
        var headerSnapShot = dataSource.snapshot(for: .authorHeader)
        var photosSnapShot = dataSource.snapshot(for: .authorPhotos)
        var hashTagsSnapShot = dataSource.snapshot(for: .authorHashTags)
        var introductionSnapShot = dataSource.snapshot(for: .authorIntroduction)
        
        headerSnapShot.append([ProfileSectionItem(profile: author.profile)])
        photosSnapShot.append(author.filters)
        hashTagsSnapShot.append([ProfileSectionItem(profile: author.profile)])
        introductionSnapShot.append([ProfileSectionItem(profile: author.profile)])
        
        dataSource.apply(headerSnapShot, to: .authorHeader)
        dataSource.apply(photosSnapShot, to: .authorPhotos)
        dataSource.apply(hashTagsSnapShot, to: .authorHashTags)
        dataSource.apply(introductionSnapShot, to: .authorIntroduction)
    }
    
    func banner(at index: Int) -> Banner? {
        let snapShot = dataSource.snapshot(for: .banner)
        guard 0...bannerCount ~= index,
              let banner = snapShot.items[index] as? Banner else { return nil }
        return banner
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
    }
    
    func configureCompositionalLayout() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch Section(rawValue: sectionIndex) {
            case .todayFilter:
                return TodayFilterCollectionViewCell.layoutSection()
            case .banner:
                return BannerCollectionViewCell.layoutSection { [weak self] items, point, environment in
                    guard let self else { return }
    
                    let width = self.collectionView.bounds.width
                    let scrollOffset = point.x
                    let contentOffset = scrollOffset.truncatingRemainder(dividingBy: width)
                    let centerX = width / 2.0
                    let pageIndex = Int(scrollOffset / width)
                    
                    if centerX < contentOffset {
                        self.updateBannerPageIndicator(index: pageIndex + 1)
                    } else {
                        self.updateBannerPageIndicator(index: pageIndex)
                    }
                }
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
        
        // 데코레이션 뷰 등록
        layout.register(
            BannerPageIndicatorDecorationView.self,
            forDecorationViewOfKind: BannerPageIndicatorDecorationView.identifier
        )
        
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
        
        // 배너
        collectionView.register(
            BannerCollectionViewCell.self,
            forCellWithReuseIdentifier: BannerCollectionViewCell.identifier
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
                    guard let item = itemIdentifier as? Filter,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TodayFilterCollectionViewCell.identifier,
                            for: indexPath
                          ) as? TodayFilterCollectionViewCell else {
                        
                        return .init()
                    }
                    cell.configureCell(filter: item)
                    return cell
                    
                case .banner:
                    guard let item = itemIdentifier as? Banner,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: BannerCollectionViewCell.identifier,
                            for: indexPath
                          ) as? BannerCollectionViewCell else {
                        return .init()
                    }
                    cell.configureCell(item)
                    return cell
                    
                case .hotTrend:
                    guard let item = itemIdentifier as? Filter,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: HotTrendCollectionViewCell.identifier,
                            for: indexPath
                          ) as? HotTrendCollectionViewCell else {
                        return .init()
                    }
                    cell.configureCell(filter: item)
                    return cell
                    
                case .authorHeader:
                    guard let item = itemIdentifier as? ProfileSectionItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TodayAuthorProfileCollectionViewCell.identifier,
                            for: indexPath
                          ) as? TodayAuthorProfileCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(profile: item.profile)
                    return cell
                    
                case .authorPhotos:
                    guard let item = itemIdentifier as? Filter,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TodayAuthorPhotosCollectionViewCell.identifier,
                            for: indexPath
                          ) as? TodayAuthorPhotosCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(imageFiles: item.files ?? [])
                    return cell
                    
                case .authorHashTags:
                    guard let item = itemIdentifier as? ProfileSectionItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: HashTagCollectionViewCell.identifier,
                            for: indexPath
                          ) as? HashTagCollectionViewCell else {
                        return .init()
                    }
                    
                    let hashTag = item.profile.hashTags[indexPath.item]
                    cell.configureCell(text: hashTag, xmarkIsHidden: true)
                    return cell
                    
                case .authorIntroduction:
                    guard let item = itemIdentifier as? ProfileSectionItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TodayAuthorIntroductionCollectionViewCell.identifier,
                            for: indexPath
                          ) as? TodayAuthorIntroductionCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(
                        header: item.profile.introduction,
                        body: item.profile.description ?? ""
                    )
                    return cell
                    
                case .none:
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
            
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .hotTrend:
                headerView.configure(leading: "핫 트렌드")
            case .authorHeader:
                headerView.configure(leading: "오늘의 작가 소개")
            default:
                break
            }
            
            return headerView
        }
    }
}


// MARK: - Banner Auto Scroll

private extension HomeView {
    func startBannerAutoScroll() {
        guard bannerCount > 1 else { return }
        
        bannerTimer = Timer.scheduledTimer(
            withTimeInterval: 2.0,
            repeats: true
        ) { [weak self] _ in
            self?.scrollToNextBanner()
        }
    }
    
    func stopBannerAutoScroll() {
        bannerTimer?.invalidate()
        bannerTimer = nil
    }
    
    func scrollToNextBanner() {
        guard bannerCount > 0 else {
            return
        }
        
        currentBannerPageIndex = (currentBannerPageIndex + 1) % bannerCount
        
        let bannerIndexPath = IndexPath(
            item: currentBannerPageIndex,
            section: Section.banner.rawValue
        )
        
        collectionView.scrollToItem(
            at: bannerIndexPath,
            at: .centeredHorizontally,
            animated: true
        )
        
        updateBannerPageIndicator(index: currentBannerPageIndex)
    }
    
    func updateBannerPageIndicator(index: Int) {
        bannerPageIndicator?.updatePage(
            current: index + 1
        )
    }
    
    func cachingBannerPageIndicatorView() {
        for subview in collectionView.subviews {
            if let decorationView = subview as? BannerPageIndicatorDecorationView {
                bannerPageIndicator = decorationView
                break
            }
        }
    }
}

// MARK: - Model

private extension HomeView {
    struct ProfileSectionItem: Hashable {
        let id = UUID()
        let profile: Profile
    }
}


#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    HomeViewController()
}
#endif
