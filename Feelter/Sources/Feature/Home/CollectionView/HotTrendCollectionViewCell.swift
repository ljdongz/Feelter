//
//  BodyCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/5/25.
//

import UIKit

final class HotTrendCollectionViewCell: BaseCollectionViewCell {
    static let identifier = "HotTrendCollectionViewCell"
    
    private let bodyContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - Setup View
    override func setupSubviews() {
        contentView.addSubview(bodyContainerView)
    }
    
    override func setupConstraints() {
        bodyContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
