//
//  HashTagCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 7/30/25.
//

import UIKit

import RxSwift
import SnapKit

final class HashTagCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HashTagCollectionViewCell"
    
    let hashTagButton: HashTagButton = {
        let button = HashTagButton()
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(hashTagButton)
        
        hashTagButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(text: String, xmarkIsHidden: Bool = false) {
        hashTagButton.textLabel.text = text
        hashTagButton.xmarkImageView.isHidden = xmarkIsHidden
    }
}

extension HashTagCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .estimated(64),
            heightDimension: .absolute(24)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(60)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 0, trailing: 20)
        
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .none
        return section
    }
}
