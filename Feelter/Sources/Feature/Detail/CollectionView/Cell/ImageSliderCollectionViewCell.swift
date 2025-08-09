//
//  FilterComparisonCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/9/25.
//

import UIKit

import SnapKit

final class ImageSliderCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "ImageSliderCollectionViewCell"
    
    private lazy var afterImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = .sample
        return view
    }()
    
    private let maskingView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var beforeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = .sample2
        return view
    }()
    
    override func setupView() {
        contentView.layer.cornerRadius = 24
        contentView.clipsToBounds = true
    }
    
    override func setupSubviews() {
        contentView.addSubviews([
            afterImageView,
            maskingView
        ])
        
        maskingView.addSubview(beforeImageView)
    }
    
    override func setupConstraints() {
        afterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        maskingView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.width.equalTo(contentView.snp.width).multipliedBy(0.5)
        }
        
        beforeImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges)
        }
    }
}

extension ImageSliderCollectionViewCell {
    
    static func layoutSection() -> NSCollectionLayoutSection {
        
        let screenWidth = UIScreen.main.bounds.width
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .absolute(screenWidth - 40),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(screenWidth - 40)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(30)),
            
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        section.contentInsets = .init(top: 0, leading: 20, bottom: 12, trailing: 20)
        section.boundarySupplementaryItems = [footer]
        return section
    }
    
}
