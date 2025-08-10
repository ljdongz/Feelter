//
//  PhotoMetadataView.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import MapKit
import UIKit

import SnapKit

final class PhotoMetadataView: BaseView {

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
        view.text = "Apple iPhone 16 Pro"
        view.textColor = .deepTurquoise
        view.font = .pretendard(size: 12, weight: .semiBold)
        return view
    }()

    private let headerTrailingLabel: UILabel = {
        let view = UILabel()
        view.text = "EXIF"
        view.textColor = .deepTurquoise
        view.font = .pretendard(size: 12, weight: .semiBold)
        return view
    }()
    
    private let metadataContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blackTurquoise
        return view
    }()
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        view.preferredConfiguration = MKStandardMapConfiguration()
        view.isZoomEnabled = false
        view.isScrollEnabled = false
        view.isPitchEnabled = false
        view.isRotateEnabled = false
        view.showsCompass = false
        view.showsScale = false
        view.showsUserLocation = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let metadataStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 8
        return view
    }()

    private let firstLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray75
        view.font = .pretendard(size: 12, weight: .semiBold)
        return view
    }()
    
    private let secondLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray75
        view.font = .pretendard(size: 12, weight: .semiBold)
        return view
    }()
    
    private let thirdLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray75
        view.font = .pretendard(size: 12, weight: .semiBold)
        return view
    }()
    
    var photoMetadata: PhotoMetadata? {
        didSet {
            updateUI(metadata: photoMetadata)
        }
    }
    
    // TODO: 삭제
    override func setupView() {
        updateUI(metadata: nil)
    }
    
    override func setupSubviews() {
        addSubview(containerView)
        
        containerView.addSubviews([
            headerView,
            metadataContainerView
        ])
        
        headerView.addSubviews([
            headerLeadingLabel,
            headerTrailingLabel
        ])
        
        metadataContainerView.addSubviews([
            mapView,
            metadataStackView
        ])
        
        metadataStackView.addArrangedSubviews([
            firstLabel,
            secondLabel,
            thirdLabel
        ])
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
        
        metadataContainerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(6)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        mapView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(8)
            make.size.equalTo(100)
        }
        
        metadataStackView.snp.makeConstraints { make in
            make.leading.equalTo(mapView.snp.trailing).offset(15)
            make.trailing.lessThanOrEqualToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }
    }
    
    private func updateUI(metadata: PhotoMetadata?) {
        
        firstLabel.text = "와이드 카메라 - 26 mm 1.5 ISO 400"
        secondLabel.text = "12MP • 3024 x 4032 • 2.2MB"
        thirdLabel.text = "서울 영등포구 선유로 9길 30"
        
        // 중심값(필수): 위, 경도
        let center = CLLocationCoordinate2D(
            latitude: 37.51775,
            longitude: 126.886557
        )

        // center를 중심으로 지정한 미터(m)만큼의 영역을 보여줌
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )

        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(
            latitude: 37.51775,
            longitude: 126.886557
        )
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    PhotoMetadataView()
}
#endif
