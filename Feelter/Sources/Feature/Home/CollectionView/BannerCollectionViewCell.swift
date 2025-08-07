//
//  BannerCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import UIKit

import SnapKit

final class BannerCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "BannerCollectionViewCell"
    
    private lazy var bannerImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 24
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bannerImageView.image = nil
    }
    
    override func setupSubviews() {
        contentView.addSubview(bannerImageView)
    }
    
    override func setupConstraints() {
        bannerImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(_ banner: Banner) {
        ImageLoader.applyAuthenticatedImage(
            for: bannerImageView,
            path: banner.imageURL
        )
    }
}

extension BannerCollectionViewCell {
    static func layoutSection(visibleHandler: @escaping ([any NSCollectionLayoutVisibleItem], CGPoint, any NSCollectionLayoutEnvironment) -> Void) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let screenWidth = UIScreen.main.bounds.width
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(screenWidth - 40),
                heightDimension: .absolute(100)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 40
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let pageIndicatorDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: BannerPageIndicatorDecorationView.identifier
        )
        pageIndicatorDecoration.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        pageIndicatorDecoration.zIndex = 100  // 배너 위에 표시
        
        section.decorationItems = [pageIndicatorDecoration]
        section.visibleItemsInvalidationHandler = visibleHandler
        return section
    }
}
