//
//  BodyCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/5/25.
//

import UIKit

final class HotTrendCollectionViewCell: BaseCollectionViewCell {
    static let identifier = "HotTrendCollectionViewCell"
    
    private let filterFeedView: FilterFeedImageView = {
        let view = FilterFeedImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - Setup View
    override func setupSubviews() {
        contentView.addSubview(filterFeedView)
    }
    
    override func setupConstraints() {
        filterFeedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(_ filter: Filter) {
        filterFeedView.titleLabel.text = filter.title
        filterFeedView.imageView.image = .sample
        filterFeedView.likeImageView.image = filter.isLiked == true ? .likeFill : .likeEmpty
        filterFeedView.likeCountLabel.text = "\(filter.likeCount ?? 0)"
    }
}

extension HotTrendCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(200),
            heightDimension: .absolute(240)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
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
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        return section
    }
}
