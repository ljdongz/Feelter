//
//  FilterPresetsView.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import UIKit

import SnapKit

final class FilterAttributeGridView: BaseView {

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.blackTurquoise.cgColor
        view.layer.borderWidth = 2
        view.clipsToBounds = true
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        return view
    }()

    private let headerLeadingLabel: UILabel = {
        let view = UILabel()
        view.text = "Filter Presets"
        view.textColor = .deepTurquoise
        view.font = .pretendard(size: 12, weight: .semiBold)
        return view
    }()

    private let headerTrailingLabel: UILabel = {
        let view = UILabel()
        view.text = "LUT"
        view.textColor = .deepTurquoise
        view.font = .pretendard(size: 12, weight: .semiBold)
        return view
    }()
    
    private let attributeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blackTurquoise
        return view
    }()
    
    private let attributeStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 20
        return view
    }()
    
    private let firstRowStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 20
        return view
    }()
    
    private let secondRowStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 20
        return view
    }()
    
    private let attributeViews: [FilterAttributeItemView] = {
        let presets: [FilterAttributeType] = [
            .brightness, .exposure, .contrast, .saturation, .sharpness, .blur,
            .vignette, .noiseReduction, .highlights, .shadows, .temperature, .blackPoint
        ]
        return presets.map { preset in
            let view = FilterAttributeItemView()
            view.attributeType = preset
            return view
        }
    }()

    override func setupSubviews() {
        addSubview(containerView)
        
        containerView.addSubviews([
            headerView,
            attributeContainerView
        ])
        
        attributeContainerView.addSubview(attributeStackView)
        
        headerView.addSubviews([
            headerLeadingLabel,
            headerTrailingLabel
        ])
        
        attributeStackView.addArrangedSubviews([
            firstRowStackView,
            secondRowStackView
        ])
        
        // 첫 번째 줄에 6개
        for i in 0..<6 {
            firstRowStackView.addArrangedSubview(attributeViews[i])
        }
        
        // 두 번째 줄에 6개
        for i in 6..<12 {
            secondRowStackView.addArrangedSubview(attributeViews[i])
        }
    }
    
    override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(6)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(20)
        }
        
        headerLeadingLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        headerTrailingLabel.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
        
        attributeContainerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(6)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        attributeStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    func applyValue(attribute: FilterAttribute) {
        attributeViews[0].value = attribute.brightness
        attributeViews[1].value = attribute.exposure
        attributeViews[2].value = attribute.contrast
        attributeViews[3].value = attribute.saturation
        attributeViews[4].value = attribute.sharpness
        attributeViews[5].value = attribute.blur
        attributeViews[6].value = attribute.vignette
        attributeViews[7].value = attribute.noiseReduction
        attributeViews[8].value = attribute.highlights
        attributeViews[9].value = attribute.shadows
        attributeViews[10].value = attribute.temperature
        attributeViews[11].value = attribute.blackPoint
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    FilterAttributeGridView()
}
#endif
