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
        
    }
    
    func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch Section(rawValue: indexPath.section) {
                case .imageSlider:
                    guard let item = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: ImageSliderCollectionViewCell.identifier,
                            for: indexPath
                          ) as? ImageSliderCollectionViewCell else {
                        return .init()
                    }
                    
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
