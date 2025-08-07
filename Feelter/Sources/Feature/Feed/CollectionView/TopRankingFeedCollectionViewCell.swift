//
//  TopRankingFeedCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import UIKit

import SnapKit

final class TopRankingFeedCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "TopRankingFeedCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blackTurquoise
        view.layer.borderColor = UIColor.deepTurquoise.cgColor
        view.layer.borderWidth = 2
        view.clipsToBounds = true
        return view
    }()
    
    private let filterImageView: UIImageView = {
        let view = UIImageView()
        view.image = .sample
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let nicknameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray75
        view.font = .pretendard(size: 12, weight: .semiBold)
        return view
    }()
    
    private let filterTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray30
        view.font = .hakgyoansimMulgyeol(size: 32, weight: .bold)
        return view
    }()
    
    private let rankLabel: UILabel = {
        let view = UILabel()
        view.textColor = .brightTurquoise
        view.font = .hakgyoansimMulgyeol(size: 32, weight: .bold)
        view.layer.borderColor = UIColor.deepTurquoise.cgColor
        view.layer.borderWidth = 2
        view.backgroundColor = .blackTurquoise
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.textAlignment = .center
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = containerView.bounds.width / 2
        filterImageView.layer.cornerRadius = filterImageView.bounds.width / 2
    }

    override func setupSubviews() {
        contentView.addSubviews([
            containerView,
            rankLabel
        ])
        
        containerView.addSubviews([
            filterImageView,
            nicknameLabel,
            filterTitleLabel
        ])
    }
    
    override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        filterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(filterImageView.snp.width)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(filterImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        filterTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        rankLabel.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(containerView.snp.bottom)
        }
    }
    
    func configureCell() {
        nicknameLabel.text = "YOON SESAC"
        filterTitleLabel.text = "청록 새록"
        rankLabel.text = "1"
        
        Task { @MainActor in
            self.containerView.layer.cornerRadius = self.containerView.bounds.width / 2
            self.filterImageView.layer.cornerRadius = self.filterImageView.bounds.width / 2
        }
    }
}

extension TopRankingFeedCollectionViewCell {
    static func layoutSection(visibleHandler: (([NSCollectionLayoutVisibleItem], CGPoint, any NSCollectionLayoutEnvironment) -> Void)? = nil) -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(220),
                heightDimension: .absolute(380)
            ),
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
        section.contentInsets = .init(top: 0, leading: 20, bottom: 30, trailing: 20)
        section.interGroupSpacing = 40
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = visibleHandler
        return section
    }
}
