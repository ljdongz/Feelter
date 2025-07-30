//
//  HashTagBtn.swift
//  Feelter
//
//  Created by 이정동 on 7/30/25.
//

import UIKit

import SnapKit

final class HashTagButton: UIButton {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 3
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let title: UILabel = {
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 12
        layer.borderColor = UIColor.gray75.cgColor
        layer.borderWidth = 1
        backgroundColor = .blackTurquoise
        
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(stackView)
        [title, xmarkImageView].forEach { stackView.addArrangedSubview($0) }
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
    
    func setTitle(_ title: String) {
        self.title.text = title
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.alpha = self.isHighlighted ? 0.6 : 1.0
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let titleSize = title.intrinsicContentSize
        let xmarkSize = CGSize(width: 7, height: 7) // 고정 크기 사용
        let spacing: CGFloat = 3
        let horizontalInsets: CGFloat = 14 // 7 + 7
        let verticalInsets: CGFloat = 16 // 8 + 8
        
        let width = titleSize.width + (xmarkImageView.isHidden ? 0 : xmarkSize.width + spacing) + horizontalInsets
        let height = max(titleSize.height, xmarkSize.height) + verticalInsets
        
        return CGSize(width: ceil(width), height: ceil(height))
    }
}
