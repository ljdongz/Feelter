//
//  FilterPresetsCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import UIKit

import SnapKit

final class FilterPresetsCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "FilterPresetsCollectionViewCell"
    
    private let filterAttributeGridView: FilterAttributeGridView = {
        let view = FilterAttributeGridView()
        return view
    }()
    
    override func setupSubviews() {
        contentView.addSubview(filterAttributeGridView)
    }
    
    override func setupConstraints() {
        filterAttributeGridView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureCell() {
        
    }
}

extension FilterPresetsCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(200)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 30, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
}
