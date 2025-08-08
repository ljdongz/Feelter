//
//  FilterCategoryCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import UIKit

final class FilterCategoryCollectionViewCell: BaseCollectionViewCell {
    static let identifier = "FilterCategoryCollectionViewCell"
    
    private let categoryButton: CategoryButton = {
        let view = CategoryButton()
        return view
    }()

    override func setupSubviews() {
        contentView.addSubview(categoryButton)
    }

    override func setupConstraints() {
        categoryButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(item: CategorySectionItem) {
        categoryButton.category = item.category
        categoryButton.isSelected = item.isSelected
    }
}

extension FilterCategoryCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        
        let screenWidth = UIScreen.main.bounds.width
        let spacing = (screenWidth - (20 * 2) - (56 * 5)) / 4
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .absolute(56),
            heightDimension: .absolute(56)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(56)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(40)),
            
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        section.boundarySupplementaryItems = [footer]
        section.contentInsets = .init(top: 20, leading: 20, bottom: 10, trailing: 20)
        return section
    }
}
