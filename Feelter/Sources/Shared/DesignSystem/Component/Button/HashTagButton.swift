//
//  HashTagBtn.swift
//  Feelter
//
//  Created by 이정동 on 7/30/25.
//

import UIKit

import SnapKit

final class HashTagButton: UIView {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 3
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.text = "#섬세함"
        view.font = .pretendard(size: 12, weight: .medium)
        view.textColor = .gray60
        return view
    }()
    
    let xmarkImageView: UIImageView = {
        let view = UIImageView(image: .xmark)
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray60
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupView() {
        layer.cornerRadius = 12
        layer.borderColor = UIColor.gray75.cgColor
        layer.borderWidth = 1
        backgroundColor = .blackTurquoise
    }
    
    private func setupSubviews() {
        addSubview(stackView)
        [textLabel, xmarkImageView].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(7)
            make.centerY.equalToSuperview()
        }
        
        xmarkImageView.snp.makeConstraints { make in
            make.size.equalTo(7)
        }
    }
}
