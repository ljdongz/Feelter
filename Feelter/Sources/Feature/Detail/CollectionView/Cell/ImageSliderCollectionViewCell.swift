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
    
    private var maskWidthConstraint: Constraint?
    
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
            maskWidthConstraint = make.width.equalTo(contentView.snp.width).multipliedBy(0.5).constraint
        }
        
        beforeImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges)
        }
    }
    
    func updateSliderPosition(value: CGFloat) {
        // 마스크 뷰 너비 조정 (이미지는 고정, 마스크만 변경)
        let targetWidth = contentView.frame.width * value
        
        // 기존 maskingView가 위치했던 x좌표
        let originalOffset = (contentView.bounds.width / 2)
        
        // 기존 maskingView의 x좌표를 기준으로 업데이트
        // Ex) targetWidth = 0이면, -originalOffset을 넣어줌으로써 maskingView의 x좌표가 contentView leading에 맞추도록 함
        maskWidthConstraint?.update(offset: targetWidth - originalOffset)
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
        
        section.contentInsets = .init(top: 10, leading: 20, bottom: 12, trailing: 20)
        section.boundarySupplementaryItems = [footer]
        return section
    }
    
}
