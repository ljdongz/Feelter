//
//  FilterFeedListCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import UIKit

import SnapKit

final class FilterFeedListCollectionViewCell: BaseCollectionViewCell {
    static let identifier = "FilterFeedListCollectionViewCell"
    
    private let filterImageView: FilterFeedSmallImageView = {
        let view = FilterFeedSmallImageView()
        return view
    }()
    
    private let labelStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 8
        return view
    }()
    
    private let filterTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray30
        view.font = .hakgyoansimMulgyeol(size: 20, weight: .bold)
        return view
    }()

    private let nicknameLabel: UILabel = {
        let view = UILabel()
        view.font = .pretendard(size: 16, weight: .medium)
        view.textColor = .gray75
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .pretendard(size: 12, weight: .regular)
        view.textColor = .gray60
        view.numberOfLines = 3
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ImageLoader.cancelDownloadTask(for: filterImageView.imageView)
    }

    override func setupSubviews() {
        contentView.addSubviews([
            filterImageView,
            labelStackView
        ])
        
        labelStackView.addArrangedSubviews([
            filterTitleLabel,
            nicknameLabel,
            descriptionLabel
        ])
    }

    override func setupConstraints() {
        filterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(120)
            make.centerY.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(filterImageView.snp.trailing).offset(20)
            make.centerY.equalTo(filterImageView.snp.centerY)
            make.trailing.equalToSuperview()
        }
    }
    
    func configureCell(filter: Filter) {
        filterImageView.imageView.image = .sample
        filterTitleLabel.text = filter.title
        nicknameLabel.text = filter.creator?.nickname
        descriptionLabel.text = filter.creator?.introduction
        
        ImageLoader.applyAuthenticatedImage(
            for: filterImageView.imageView,
            path: filter.files?.first ?? ""
        )
    }
}

extension FilterFeedListCollectionViewCell {
    static func layoutSection(visibleHandler: (([NSCollectionLayoutVisibleItem], CGPoint, any NSCollectionLayoutEnvironment) -> Void)? = nil) -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(152)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(59)),
            
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 0, leading: 20, bottom: 50, trailing: 20)
        
        section.visibleItemsInvalidationHandler = visibleHandler
        return section
    }
}
