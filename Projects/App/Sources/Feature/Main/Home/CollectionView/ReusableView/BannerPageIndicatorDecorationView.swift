//
//  BannerPageIndicatorDecorationView.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import UIKit

import SnapKit

final class BannerPageIndicatorDecorationView: UICollectionReusableView {
    
    static let identifier = "BannerPageIndicatorDecorationView"
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray75.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray60.withAlphaComponent(0.5).cgColor
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let pageLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray45
        view.font = .pretendard(size: 10, weight: .medium)
        return view
    }()
    
    private var total: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = false
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(backgroundView)
        backgroundView.addSubview(pageLabel)
    }
    
    private func setupConstraints() {
        
        backgroundView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-40) // 섹션 inset 20 + 여백 20
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(44)
            make.height.equalTo(20)
        }
        
        pageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureView(total: Int) {
        self.total = total
        pageLabel.text = "1 / \(total)"
    }
    
    func updatePage(current: Int) {
        pageLabel.text = "\(current) / \(total)"
    }
}
