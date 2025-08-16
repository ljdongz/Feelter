//
//  CounterStateCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import UIKit

import SnapKit

final class CounterStateCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "CounterStateCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let downloadContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blackTurquoise
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let downloadLabel: UILabel = {
        let view = UILabel()
        view.text = "다운로드"
        view.textColor = .gray75
        view.font = .pretendard(size: 12, weight: .semiBold)
        view.frame.size = view.intrinsicContentSize
        return view
    }()
    
    private let downloadCounterLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray30
        view.font = .pretendard(size: 20, weight: .bold)
        return view
    }()

    private let likeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blackTurquoise
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let likeLabel: UILabel = {
        let view = UILabel()
        view.text = "좋아요"
        view.textColor = .gray75
        view.font = .pretendard(size: 12, weight: .semiBold)
        view.frame.size = view.intrinsicContentSize
        return view
    }()
    
    private let likeCounterLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray30
        view.font = .pretendard(size: 20, weight: .bold)
        return view
    }()
    
    override func setupSubviews() {
        contentView.addSubview(containerView)
        
        containerView.addSubviews([
            downloadContainerView,
            likeContainerView
        ])
        
        downloadContainerView.addSubviews([
            downloadLabel,
            downloadCounterLabel
        ])
        
        likeContainerView.addSubviews([
            likeLabel,
            likeCounterLabel
        ])
    }
    
    override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        downloadContainerView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.trailing.equalTo(containerView.snp.centerX).offset(-4)
        }
        
        downloadLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(7)
            make.centerX.equalToSuperview()
        }
        
        downloadCounterLabel.snp.makeConstraints { make in
            make.top.equalTo(downloadLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(7)
        }
        
        likeContainerView.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
            make.leading.equalTo(containerView.snp.centerX).offset(4)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(7)
            make.centerX.equalToSuperview()
        }
        
        likeCounterLabel.snp.makeConstraints { make in
            make.top.equalTo(likeLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(7)
        }
    }

    func configureCell(item: FilterDetailView.CounterStateSectionItem) {
        downloadCounterLabel.text = "\(item.downloadCount)"
        likeCounterLabel.text = "\(item.likeCount)"
    }
}

extension CounterStateCollectionViewCell {
    
    static func layoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(0.6),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(56)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 20, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
}
