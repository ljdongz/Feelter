//
//  FilterAttributeCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/25/25.
//

import UIKit

import SnapKit

final class FilterAttributeCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "FilterAttributeCollectionViewCell"
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray75
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray75
        view.font = .pretendard(size: 10, weight: .semiBold)
        view.textAlignment = .center
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            let color: UIColor = isSelected ? .gray30 : .gray75
            imageView.tintColor = color
            titleLabel.textColor = color
        }
    }

    override func setupSubviews() {
        contentView.addSubviews([
            imageView,
            titleLabel
        ])
    }

    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    func configureCell(item: FilterAttributeType) {
        titleLabel.text = item.title
        imageView.image = item.image
        
    }
}

extension FilterAttributeCollectionViewCell {
    
    static func layoutSection(
        visibleHandler: @escaping (
            [any NSCollectionLayoutVisibleItem],
            CGPoint,
            any NSCollectionLayoutEnvironment
        ) -> Void
    ) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(52),
                heightDimension: .absolute(52)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sideInset = (UIScreen.main.bounds.width - 52) / 2
        
        section.contentInsets = .init(top: 14, leading: sideInset, bottom: 14, trailing: sideInset)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 20
        
        section.visibleItemsInvalidationHandler = visibleHandler
        return section
    }
}


