//
//  BaseTextFieldCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/11/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

typealias BaseTextFieldCellItem = BaseTextFieldCollectionViewCell.Item

final class BaseTextFieldCollectionViewCell: RxBaseCollectionViewCell {
    
    static let identifier = "BaseTextFieldCollectionViewCell"
    
    struct Item: Hashable {
        enum InputType {
            case text
            case number
        }
        let placeholder: String?
        var suffix: String? = nil
        let inputType: InputType
    }
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.deepTurquoise.cgColor
        view.layer.borderWidth = 2
        view.tintColor = .gray75
        view.textColor = .gray45
        view.delegate = self
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        view.leftView = paddingView
        view.leftViewMode = .always
        
        return view
    }()
    
    private let suffixLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray45
        label.font = .pretendard(size: 14, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    let textFieldDidBeginEditingTrigger = PublishRelay<UITextField>()
    
    override func setupSubviews() {
        contentView.addSubview(textField)
        contentView.addSubview(suffixLabel)
    }
    
    override func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        suffixLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
    func configureCell(item: BaseTextFieldCellItem) {
        textField.attributedPlaceholder = NSAttributedString(
            string: item.placeholder ?? "",
            attributes: [
                .foregroundColor: UIColor.deepTurquoise
            ]
        )
        textField.keyboardType = item.inputType == .number ? .numberPad : .default
        configureSuffix(item.suffix)
    }
    
    private func configureSuffix(_ suffix: String?) {
        if let suffix = suffix {
            suffixLabel.text = suffix
            suffixLabel.isHidden = false
            
            let rightPaddingView = UIView(frame: CGRect(
                x: 0,
                y: 0,
                width: suffixLabel.intrinsicContentSize.width + 24,
                height: 0
            ))
            textField.rightView = rightPaddingView
            textField.rightViewMode = .always
        } else {
            suffixLabel.isHidden = true
            textField.rightView = nil
            textField.rightViewMode = .never
        }
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

extension BaseTextFieldCollectionViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textFieldDidBeginEditingTrigger.accept(textField)
    }
}
