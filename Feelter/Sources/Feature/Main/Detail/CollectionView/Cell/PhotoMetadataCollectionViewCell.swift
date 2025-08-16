//
//  PhotoMetadataCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import UIKit

import SnapKit

final class PhotoMetadataCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "PhotoMetadataCollectionViewCell"
    
    private let metadataView: PhotoMetadataView = {
        let view = PhotoMetadataView()
        return view
    }()

    override func setupSubviews() {
        contentView.addSubview(metadataView)
    }
    
    override func setupConstraints() {
        metadataView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(photoMetadata: PhotoMetadata?) {
        metadataView.photoMetadata = photoMetadata
    }
}

extension PhotoMetadataCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(150)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 30, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
}
