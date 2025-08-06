//
//  TodayAuthorPhotosCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/5/25.
//

import UIKit

import SnapKit

final class TodayAuthorPhotosCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "TodayAuthorPhotosCollectionViewCell"
    
    private lazy var photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ImageLoader.cancelDownloadTask(for: photoImageView)
        photoImageView.image = nil
    }
    
    override func setupSubviews() {
        contentView.addSubview(photoImageView)
    }
    
    override func setupConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(imageFiles: [String]) {
        // TODO: 원본, 필터 이미지 중 어느것을 보여줄지 고민
        ImageLoader.applyAuthenticatedImage(
            for: photoImageView,
            path: imageFiles[0]
        )
    }
}

extension TodayAuthorPhotosCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(120),
                heightDimension: .absolute(80)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 20, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .paging
        return section
    }
}
