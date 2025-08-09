//
//  SortingButton.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import UIKit

import SnapKit

final class CapsuleButton: BaseView {

    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            containerView.layer.borderWidth = isSelected ? 1 : 0
            containerView.layer.borderColor = isSelected ? UIColor.deepTurquoise.cgColor : nil
            containerView.backgroundColor = isSelected ? .brightTurquoise : .blackTurquoise
            titleLabel.textColor = isSelected ? .gray45 : .gray75
            titleLabel.font = .pretendard(size: 12, weight: isSelected ? .bold : .medium)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.layer.cornerRadius = containerView.bounds.height / 2
    }
    
    override func setupSubviews() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(7)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
}
