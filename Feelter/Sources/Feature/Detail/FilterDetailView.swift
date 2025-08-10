//
//  FilterDetailView.swift
//  Feelter
//
//  Created by 이정동 on 8/9/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class FilterDetailView: BaseView {
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<Section, AnyHashable>

    enum Section: Int {
        case imageSlider
        case counterState
        case presets
        case photoMetadata
        case authorProfile
        case authorHashTags
        case authorIntroduction
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
    private weak var imageSliderCell: ImageSliderCollectionViewCell?
    
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
    
    func applySnapShot(filter: FilterDetail) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapShot.appendSections([.imageSlider, .counterState, .presets, .photoMetadata, .authorProfile, .authorHashTags, .authorIntroduction])
        
        let imageSlider = ImageSliderSectionItem(
            originalImageUrl: filter.imageURLs[0],
            filteredImageUrl: filter.imageURLs[1]
        )
        let counterState = CounterStateSectionItem(
            downloadCount: filter.buyerCount,
            likeCount: filter.likeCount
        )
        let attribute = FilterAttributeSectionItem(attribute: filter.attribute)
        let metadata = PhotoMetadataSectionItem(metadata: filter.photoMetadata)
        let profile = AuthorProfileSectionItem(
            profileImageURL: filter.author.profileImageURL,
            name: filter.author.name,
            nickname: filter.author.nickname
        )
        let hashTags = filter.author.hashTags.map { HashTagsSectionItem(text: $0) }
        let introduction = IntroductionSectionItem(text: filter.author.introduction)
        
        snapShot.appendItems([imageSlider], toSection: .imageSlider)
        snapShot.appendItems([counterState], toSection: .counterState)
        snapShot.appendItems([attribute], toSection: .presets)
        snapShot.appendItems([metadata], toSection: .photoMetadata)
        snapShot.appendItems([profile], toSection: .authorProfile)
        snapShot.appendItems(hashTags, toSection: .authorHashTags)
        snapShot.appendItems([introduction], toSection: .authorIntroduction)
        
        dataSource.apply(snapShot, animatingDifferences: false)
    }
}

// MARK: - Collection Configuration

private extension FilterDetailView {
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
            case .imageSlider:
                return ImageSliderCollectionViewCell.layoutSection()
            case .counterState:
                return CounterStateCollectionViewCell.layoutSection()
            case .presets:
                return FilterPresetsCollectionViewCell.layoutSection()
            case .photoMetadata:
                return PhotoMetadataCollectionViewCell.layoutSection()
            case .authorProfile:
                return AuthorProfileCollectionViewCell.layoutSection()
            case .authorHashTags:
                return HashTagCollectionViewCell.layoutSection()
            case .authorIntroduction:
                return BaseAuthorIntroductionCollectionViewCell.layoutSection()
            default:
                return ImageSliderCollectionViewCell.layoutSection()
            }
        }
        
        collectionView.collectionViewLayout = layout
    }
    
    func registerCollectionViewCells() {
        
        // 이미지 슬라이더
        collectionView.register(
            ImageSliderCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageSliderCollectionViewCell.identifier
        )
        
        // 이미지 슬라이더 푸터
        collectionView.register(
            ImageSliderFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: ImageSliderFooterView.identifier
        )
        
        // 다운로드, 좋아요
        collectionView.register(
            CounterStateCollectionViewCell.self,
            forCellWithReuseIdentifier: CounterStateCollectionViewCell.identifier
        )
        
        // 프리셋
        collectionView.register(
            FilterPresetsCollectionViewCell.self,
            forCellWithReuseIdentifier: FilterPresetsCollectionViewCell.identifier
        )
        
        // 메타데이터
        collectionView.register(
            PhotoMetadataCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoMetadataCollectionViewCell.identifier
        )
        
        // 작가 프로필
        collectionView.register(
            AuthorProfileCollectionViewCell.self,
            forCellWithReuseIdentifier: AuthorProfileCollectionViewCell.identifier
        )
        
        // 작가 해시태그
        collectionView.register(
            HashTagCollectionViewCell.self,
            forCellWithReuseIdentifier: HashTagCollectionViewCell.identifier
        )
        
        // 작가 소개
        collectionView.register(
            BaseAuthorIntroductionCollectionViewCell.self,
            forCellWithReuseIdentifier: BaseAuthorIntroductionCollectionViewCell.identifier
        )
    }
    
    func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                switch Section(rawValue: indexPath.section) {
                case .imageSlider:
                    guard let item = itemIdentifier as? ImageSliderSectionItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: ImageSliderCollectionViewCell.identifier,
                            for: indexPath
                          ) as? ImageSliderCollectionViewCell else {
                        return .init()
                    }
                    self?.imageSliderCell = cell
                    
                    cell.configureCell(item: item)
                    return cell
                    
                case .counterState:
                    guard let item = itemIdentifier as? CounterStateSectionItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: CounterStateCollectionViewCell.identifier,
                            for: indexPath
                          ) as? CounterStateCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(item: item)
                    return cell
                    
                case .presets:
                    guard let item = itemIdentifier as? FilterAttributeSectionItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: FilterPresetsCollectionViewCell.identifier,
                            for: indexPath
                          ) as? FilterPresetsCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(item: item)
                    return cell
                    
                case .photoMetadata:
                    guard let item = itemIdentifier as? PhotoMetadataSectionItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: PhotoMetadataCollectionViewCell.identifier,
                            for: indexPath
                          ) as? PhotoMetadataCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(photoMetadata: item.metadata)
                    return cell
                    
                case .authorProfile:
                    guard let item = itemIdentifier as? AuthorProfileSectionItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: AuthorProfileCollectionViewCell.identifier,
                            for: indexPath
                          ) as? AuthorProfileCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(profile: .init(
                        userID: "",
                        email: "",
                        nickname: item.nickname,
                        name: item.name,
                        introduction: "",
                        description: "",
                        profileImageURL: item.profileImageURL,
                        phoneNumber: "",
                        hashTags: []
                    ))
                    return cell
                    
                case .authorHashTags:
                    guard let item = itemIdentifier as? HashTagsSectionItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: HashTagCollectionViewCell.identifier,
                            for: indexPath
                          ) as? HashTagCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(text: item.text, xmarkIsHidden: true)
                    return cell
                    
                case .authorIntroduction:
                    guard let item = itemIdentifier as? IntroductionSectionItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: BaseAuthorIntroductionCollectionViewCell.identifier,
                            for: indexPath
                          ) as? BaseAuthorIntroductionCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(body: item.text ?? "")
                    return cell
                    
                default:
                    return .init()
                }
            }
        )
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            if kind == UICollectionView.elementKindSectionFooter {
                guard let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ImageSliderFooterView.identifier,
                    for: indexPath
                ) as? ImageSliderFooterView else { return nil }
                
                footerView.onSliderChanged = { [weak self] value in
                    self?.imageSliderCell?.updateSliderPosition(value: value)
                }
                
                return footerView
            } else {
                return nil
            }
        }
    }
}

extension FilterDetailView {
    struct ImageSliderSectionItem: Hashable {
        let originalImageUrl: String
        let filteredImageUrl: String
    }
    
    struct CounterStateSectionItem: Hashable {
        let downloadCount: Int
        let likeCount: Int
    }
    
    struct FilterAttributeSectionItem: Hashable {
        let attribute: FilterAttribute
    }
    
    struct PhotoMetadataSectionItem: Hashable {
        let uuid = UUID()
        let metadata: PhotoMetadata?
    }
    
    struct AuthorProfileSectionItem: Hashable {
        let profileImageURL: String?
        let name: String?
        let nickname: String
    }
    
    struct HashTagsSectionItem: Hashable {
        let uuid = UUID()
        let text: String
    }
    
    struct IntroductionSectionItem: Hashable {
        let uuid = UUID()
        let text: String?
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(
        rootViewController: FilterDetailViewController(
            viewModel: FilterDetailViewModel(
                filterID: "",
                isLiked: false
            )
        )
    )
}
#endif
