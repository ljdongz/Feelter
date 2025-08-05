//
//  TodayFilterSectionHeaderView.swift
//  Feelter
//
//  Created by 이정동 on 8/5/25.
//

import UIKit

import SnapKit

final class BaseSectionHeaderView: UICollectionReusableView {
    
    static let identifier = "BaseSectionHeaderView"
    
    let sectionTitle: UILabel = {
        let view = UILabel()
        view.textColor = .gray60
        view.font = .pretendard(size: 16, weight: .bold)
        return view
    }()
    
    let sectionButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.gray75, for: .normal)
        view.titleLabel?.font = .pretendard(size: 16, weight: .medium)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([
            sectionTitle, sectionButton
        ])
        
        sectionTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        sectionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        self.sectionTitle.text = title
    }
}
