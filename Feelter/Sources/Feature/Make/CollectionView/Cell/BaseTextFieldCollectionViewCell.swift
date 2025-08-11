//
//  BaseTextFieldCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/11/25.
//

import UIKit

import SnapKit

final class BaseTextFieldCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "BaseTextFieldCollectionViewCell"
    
    let textField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.deepTurquoise.cgColor
        view.layer.borderWidth = 2
        view.tintColor = .gray75
        view.textColor = .gray45
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        view.leftView = paddingView
        view.leftViewMode = .always
        
        return view
    }()
    
    override func setupSubviews() {
        contentView.addSubview(textField)
    }
    
    override func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(placeholder: String?) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: UIColor.deepTurquoise
            ]
        )
    }
}

extension BaseTextFieldCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(45)
            ),
            subitems: [item]
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(48)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]

        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section
    }
}
