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
        
        // TODO: 삭제
        dummyDataSource()
    }
    
    func dummyDataSource() {
        var snapShot = dataSource.snapshot(for: .imageSlider)
        snapShot.append(["1"])
        dataSource.apply(snapShot, to: .imageSlider)
        
        var counterStateSnapShot = dataSource.snapshot(for: .counterState)
        counterStateSnapShot.append(["a"])
        dataSource.apply(counterStateSnapShot, to: .counterState)
        
        var presetsSnapShot = dataSource.snapshot(for: .presets)
        presetsSnapShot.append(["as"])
        dataSource.apply(presetsSnapShot, to: .presets)
        
        var photoMetadataSnapShot = dataSource.snapshot(for: .photoMetadata)
        photoMetadataSnapShot.append(["pf"])
        dataSource.apply(photoMetadataSnapShot, to: .photoMetadata)
        
        var profileSnapShot = dataSource.snapshot(for: .authorProfile)
        profileSnapShot.append(["asdf"])
        dataSource.apply(profileSnapShot, to: .authorProfile)
        
        var hashTagsSnapShot = dataSource.snapshot(for: .authorHashTags)
        hashTagsSnapShot.append(["32543123", "32542451", "43531", "5325325135", "32442", "23dk214k"])
        dataSource.apply(hashTagsSnapShot, to: .authorHashTags)
        
        var authorIntroductionSnapShot = dataSource.snapshot(for: .authorIntroduction)
        authorIntroductionSnapShot.append(["안녕하세요, 잘 부탁드립니다."])
        dataSource.apply(authorIntroductionSnapShot, to: .authorIntroduction)
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
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: ImageSliderCollectionViewCell.identifier,
                            for: indexPath
                          ) as? ImageSliderCollectionViewCell else {
                        return .init()
                    }
                    self?.imageSliderCell = cell
                    return cell
                    
                case .counterState:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: CounterStateCollectionViewCell.identifier,
                            for: indexPath
                          ) as? CounterStateCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell()
                    return cell
                    
                case .presets:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: FilterPresetsCollectionViewCell.identifier,
                            for: indexPath
                          ) as? FilterPresetsCollectionViewCell else {
                        return .init()
                    }
                    
                    return cell
                    
                case .photoMetadata:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: PhotoMetadataCollectionViewCell.identifier,
                            for: indexPath
                          ) as? PhotoMetadataCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(photoMetadata: nil)
                    return cell
                    
                case .authorProfile:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: AuthorProfileCollectionViewCell.identifier,
                            for: indexPath
                          ) as? AuthorProfileCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(profile: nil)
                    return cell
                    
                case .authorHashTags:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: HashTagCollectionViewCell.identifier,
                            for: indexPath
                          ) as? HashTagCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(text: item, xmarkIsHidden: true)
                    return cell
                    
                case .authorIntroduction:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: BaseAuthorIntroductionCollectionViewCell.identifier,
                            for: indexPath
                          ) as? BaseAuthorIntroductionCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(body: item)
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

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: FilterDetailViewController())
}
#endif
