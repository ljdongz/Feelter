//
//  FilterPresetsCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import UIKit

import RxSwift
import SnapKit

typealias FilterPresetsCellItem = FilterPresetsCollectionViewCell.Item

final class FilterPresetsCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "FilterPresetsCollectionViewCell"
    
    private(set) var disposeBag = DisposeBag()
    
    struct Item: Hashable {
        let isPaid: Bool
        let attribute: FilterAttribute
    }
    
    private let filterAttributeGridView: FilterAttributeGridView = {
        let view = FilterAttributeGridView()
        return view
    }()
    
    let paymentButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = .pretendard(size: 20, weight: .bold)
        view.layer.cornerRadius = 8
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func setupSubviews() {
        contentView.addSubviews([
            filterAttributeGridView,
            paymentButton
        ])
    }
    
    override func setupConstraints() {
        filterAttributeGridView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        paymentButton.snp.makeConstraints { make in
            make.top.equalTo(filterAttributeGridView.snp.bottom).offset(22)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(46)
        }
    }

    func configureCell(item: FilterPresetsCellItem) {
        
        if item.isPaid {
            filterAttributeGridView.applyValue(attribute: item.attribute)
            paymentButton.setTitle("구매완료", for: .normal)
            paymentButton.setTitleColor(.gray75, for: .normal)
            paymentButton.backgroundColor = .gray90
        } else {
            filterAttributeGridView.applyValue(attribute: .zero)
            paymentButton.setTitle("결제하기", for: .normal)
            paymentButton.setTitleColor(.gray30, for: .normal)
            paymentButton.backgroundColor = .brightTurquoise
        }
        
        filterAttributeGridView.isAttributeLocked = !item.isPaid
        paymentButton.isEnabled = !item.isPaid
    }
}

extension FilterPresetsCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(250)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(250)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 30, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
}
