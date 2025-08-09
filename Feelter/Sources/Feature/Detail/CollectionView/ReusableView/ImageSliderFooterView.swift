//
//  SliderControlCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import UIKit

import SnapKit

final class ImageSliderFooterView: UICollectionReusableView {
    
    static let identifier = "ImageSliderFooterView"
    
    private let sliderContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private let beforeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray75.withAlphaComponent(0.5)
        view.clipsToBounds = true
        return view
    }()
    
    private let beforeLabel: UILabel = {
        let view = UILabel()
        view.text = "Before"
        view.textColor = .gray60
        view.font = .pretendard(size: 11, weight: .semiBold)
        view.textAlignment = .center
        return view
    }()
    
    private let anchorContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray75.withAlphaComponent(0.5)
        view.layer.borderColor = UIColor.gray75.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private let anchorImageView: UIImageView = {
        let view = UIImageView()
        view.image = .polygon
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray60
        return view
    }()
    
    private let afterContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray75.withAlphaComponent(0.5)
        view.clipsToBounds = true
        return view
    }()
    
    private let afterLabel: UILabel = {
        let view = UILabel()
        view.text = "After"
        view.textColor = .gray60
        view.font = .pretendard(size: 11, weight: .semiBold)
        view.textAlignment = .center
        return view
    }()
    
    var onSliderChanged: ((CGFloat) -> Void)?
    
    private var sliderValue: CGFloat = 0.5 {
        didSet {
            updateSliderPosition()
            onSliderChanged?(sliderValue) // 값 변경 알림
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupConstraints()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Task { @MainActor in
            beforeContainerView.layer.cornerRadius = beforeContainerView.bounds.height / 2
            afterContainerView.layer.cornerRadius = afterContainerView.bounds.height / 2
            anchorContainerView.layer.cornerRadius = anchorContainerView.bounds.height / 2
        }
    }
    
    private func setupSubviews() {
        
        addSubview(sliderContainerView)
        
        sliderContainerView.addSubviews([
            beforeContainerView,
            anchorContainerView,
            afterContainerView
        ])
        
        beforeContainerView.addSubview(beforeLabel)
        anchorContainerView.addSubview(anchorImageView)
        afterContainerView.addSubview(afterLabel)
    }
    
    private func setupConstraints() {
        sliderContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        beforeContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(anchorContainerView.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
            make.width.equalTo(48)
        }
        
        beforeLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.centerX.equalToSuperview()
        }
        
        anchorContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(24)
            make.verticalEdges.equalToSuperview()
        }
        
        anchorImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-1)
            make.size.equalTo(10)
        }
        
        afterContainerView.snp.makeConstraints { make in
            make.leading.equalTo(anchorContainerView.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(48)
        }
        
        afterLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.centerX.equalToSuperview()
        }
    }
    
    private func updateSliderPosition() {
        guard frame.width > 0 else { return }
        
        // sliderValue(0~1)에 따른 anchorContainerView의 절대 x 좌표
        // 0일 때: ImageSliderFooterView의 leading (0)
        // 1일 때: ImageSliderFooterView의 trailing (frame.width)
        let anchorX = frame.width * sliderValue
        
        // sliderContainerView는 중앙에 위치하므로, 중앙(frame.width / 2)에서 목표 위치(anchorX)까지의 상대적 거리 계산
        let centerOffset = anchorX - (frame.width / 2)
        sliderContainerView.transform = CGAffineTransform(translationX: centerOffset, y: 0)
        
        /*
         가정: frame.width = 300일 때

         1) sliderValue = 0.0 (맨 왼쪽)

            anchorX = 300 * 0.0 = 0
            centerOffset = 0 - (300 / 2) = 0 - 150 = -150
            => sliderContainerView가 중앙에서 왼쪽으로 150만큼 이동

         2) sliderValue = 0.5 (가운데)

           anchorX = 300 * 0.5 = 150
           centerOffset = 150 - (300 / 2) = 150 - 150 = 0
           => sliderContainerView가 중앙에 그대로 위치 (이동 없음)

         3) sliderValue = 1.0 (맨 오른쪽)

           anchorX = 300 * 1.0 = 300
           centerOffset = 300 - (300 / 2) = 300 - 150 = 150
           => sliderContainerView가 중앙에서 오른쪽으로 150만큼 이동
         */
    }
    
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        sliderContainerView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard sliderContainerView.frame.width > 0 else { return }
        
        // self 기준으로 현재 제스처가 발생하는 영역의 상대 위치
        let location = gesture.location(in: self)
        
        let newValue = max(0, min(1, location.x / frame.width))
        
        sliderValue = newValue
    }
}
