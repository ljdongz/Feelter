//
//  HeaderCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/5/25.
//

import UIKit
import SnapKit

final class TodayFilterCollectionViewCell: BaseCollectionViewCell {
    static let identifier = "TodayFilterCollectionViewCell"
    
    private let todayFilterImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let todayFilterGradientView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let todayFilterHeaderStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.axis = .vertical
        view.alignment = .leading
        return view
    }()

    private let todayFilterHeaderLabel: UILabel = {
        let view = UILabel()
        view.text = "오늘의 필터 소개"
        view.textColor = .gray60
        view.font = .pretendard(size: 13, weight: .medium)
        return view
    }()
    
    private let todayFilterIntroductionLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray30
        view.font = .hakgyoansimMulgyeol(size: 32, weight: .bold)
        return view
    }()

    private let todayFilterTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray30
        view.font = .hakgyoansimMulgyeol(size: 32, weight: .bold)
        return view
    }()

    private let todayFilterDescriptionLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray60
        view.font = .pretendard(size: 12, weight: .regular)
        view.numberOfLines = 0
        return view
    }()
    
//    private let bannerView: UIView = {
//        let view = UIView()
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 24
//        view.backgroundColor = .gray
//        return view
//    }()
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - Setup View
    override func setupSubviews() {
        contentView.addSubview(todayFilterImageView)
        
        todayFilterImageView.addSubview(todayFilterGradientView)
        
        todayFilterGradientView.addSubviews([
            todayFilterHeaderStackView,
            todayFilterDescriptionLabel,
//            bannerView
        ])
        
        todayFilterHeaderStackView.addArrangedSubviews([
            todayFilterHeaderLabel,
            todayFilterIntroductionLabel,
            todayFilterTitleLabel
        ])
    }
    
    override func setupConstraints() {
        todayFilterImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).priority(999)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(contentView.snp.height)
        }
        
        todayFilterGradientView.snp.makeConstraints { make in
            make.edges.equalTo(todayFilterImageView)
        }
        
        todayFilterHeaderStackView.snp.makeConstraints { make in
            make.bottom.equalTo(todayFilterDescriptionLabel.snp.top).offset(-20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        todayFilterDescriptionLabel.snp.makeConstraints { make in
//            make.bottom.equalTo(bannerView.snp.top).offset(-28)
            make.bottom.equalToSuperview().offset(-58)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
//        bannerView.snp.makeConstraints { make in
//            make.bottom.equalToSuperview()
//            make.horizontalEdges.equalToSuperview().inset(20)
//            make.height.equalTo(100)
//        }
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.gray100.cgColor
        ]
        
        // 그라데이션 방향 설정 (top에서 시작)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.3) // top center
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // bottom center
        
        // todayFilterImageView에만 gradient 적용, todayFilterGradientView 아래에 위치
        todayFilterImageView.layer.insertSublayer(gradientLayer, below: todayFilterGradientView.layer)
        
        Task { @MainActor in
            self.layoutIfNeeded()
            
            guard todayFilterImageView.bounds != .zero else { return }
            
            // 애니메이션 없이 즉시 적용
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            gradientLayer.frame = todayFilterImageView.bounds
            CATransaction.commit()
        }
    }
    
    func configureCell(filter: Filter) {
        // TODO: 원본, 필터 이미지 중 어느것을 보여줄지 고민
        ImageLoader.applyAuthenticatedImage(
            at: todayFilterImageView,
            path: filter.files?[0] ?? ""
        )
        
        todayFilterIntroductionLabel.text = filter.introduction
        todayFilterTitleLabel.text = filter.title
        todayFilterDescriptionLabel.text = filter.description
    }
}

extension TodayFilterCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(4.0/3.0) // 4:3 비율
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(4.0/3.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
    
        return section
    }
}
