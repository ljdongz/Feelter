//
//  PhotoPickerInputView.swift
//  Feelter
//
//  Created by 이정동 on 9/1/25.
//

import UIKit

import SnapKit

final class PhotoPickerInputView: BaseView {
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<Section, AnyHashable>

    enum Section: Int {
        case photos
    }

    private lazy var collectionView: UICollectionView = {
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
    
    override func setupView() {
        setupCollectionView()
        initializeDataSource()
    }
    
    override func setupSubviews() {
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func initializeDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        snapShot.appendSections([.photos])
        
        let datas: [UIImage?] = [.sampleImage, .sample2, .appleLogo, .blackPoint]

        snapShot.appendItems(datas.compactMap { $0 }, toSection: .photos)
        dataSource.apply(snapShot, animatingDifferences: false)
    }
}

extension PhotoPickerInputView {
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
            switch Section(rawValue: sectionIndex)! {
            case .photos:
                return PhotoCollectionViewCell.layoutSection()
            }
        }
        
        collectionView.collectionViewLayout = layout
    }
    
    func registerCollectionViewCells() {
        collectionView.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier
        )
    }
    
    func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                
                switch Section(rawValue: indexPath.section)! {
                case .photos:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PhotoCollectionViewCell.identifier,
                        for: indexPath
                    ) as? PhotoCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(image: .sampleImage)
                    cell.backgroundColor = .yellow
                    return cell
                }
            }
        )
    }
}

fileprivate final class PhotoCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setupSubviews() {
        contentView.addSubview(imageView)
    }
    
    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(image: UIImage) {
        imageView.image = image
    }
}

extension PhotoCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth - 2) / 3.0
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .absolute(width),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(width)
            ),
            subitems: [item]
        )
        
        group.interItemSpacing = .fixed(1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 1
        return section
    }
}
