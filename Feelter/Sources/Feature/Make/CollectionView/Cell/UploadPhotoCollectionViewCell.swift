//
//  UploadPhotoCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/12/25.
//

import UIKit

import SnapKit

typealias UploadPhotoItem = UploadPhotoCollectionViewCell.Item

final class UploadPhotoCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "UploadPhotoCollectionViewCell"
    
    struct Item: Hashable {
        let id = UUID()
        let image: UIImage?
    }
    
    private let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    private let plusImageView: UIImageView = {
        let view = UIImageView()
        view.image = .plus
        view.tintColor = .gray75
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private var photoHeightConstraint: Constraint?
    
    override func setupView() {
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .blackTurquoise
        contentView.clipsToBounds = true
    }

    override func setupSubviews() {
        contentView.addSubviews([
            plusImageView,
            photoImageView
        ])
    }
    
    override func setupConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            photoHeightConstraint = make.height.equalTo(150).constraint
        }
        
        plusImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(26)
        }
    }
    
    func configureCell(image: UIImage?) {
        guard let image else { return }
        
        photoImageView.image = image
        photoImageView.isHidden = false
        
        // 이미지 비율에 따른 높이 계산
        let aspectRatio = image.size.height / image.size.width
        let containerWidth = UIScreen.main.bounds.width - 40
        let newHeight = containerWidth * aspectRatio
        
        let finalHeight = max(150, newHeight)

        // 애니메이션과 함께 높이 변경
        photoHeightConstraint?.update(offset: finalHeight)
    }
}

extension UploadPhotoCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(150)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(150)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(48)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
}
