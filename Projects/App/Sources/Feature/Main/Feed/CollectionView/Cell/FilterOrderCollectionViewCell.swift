//
//  FilterOrderCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/9/25.
//

import UIKit

import SnapKit

final class FilterOrderCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "FilterOrderCollectionViewCell"

    private let capsuleButton: CapsuleButton = {
        let view = CapsuleButton()
        return view
    }()
    
    override func setupSubviews() {
        contentView.addSubview(capsuleButton)
    }
    
    override func setupConstraints() {
        capsuleButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(item: OrderSectionItem) {
        capsuleButton.isSelected = item.isSelected
        
        switch item.order {
        case .latest:
            capsuleButton.title = "최신순"
        case .popularity:
            capsuleButton.title = "인기순"
        case .purchase:
            capsuleButton.title = "구매순"
        }
    }
}

extension FilterOrderCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        
        let screenWidth = UIScreen.main.bounds.width
        let spacing = (screenWidth - (20) - (55 * 3) - (8 * 2))
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .absolute(55),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(30)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 15, leading: spacing, bottom: 0, trailing: 20)
        return section
    }
}
