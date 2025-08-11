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
    
    private let emptyLocationContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.deepTurquoise.cgColor
        view.layer.borderWidth = 2
        view.backgroundColor = .blackTurquoise
        return view
    }()
    
    private let emptyLocationImageView: UIImageView = {
        let view = UIImageView()
        view.image = .noLocation
        view.tintColor = .deepTurquoise
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let emptyLocationLabel: UILabel = {
        let view = UILabel()
        view.text = "No Location"
        view.textColor = .deepTurquoise
        view.font = .pretendard(size: 12, weight: .semiBold)
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
        view.layer.borderColor = UIColor.deepTurquoise.cgColor
        view.layer.borderWidth = 2
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
        
        mapView.addSubview(emptyLocationContainerView)
        
        emptyLocationContainerView.addSubviews([
            emptyLocationImageView,
            emptyLocationLabel
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
        
        emptyLocationContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyLocationImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(25)
            make.size.equalTo(35)
        }
        
        emptyLocationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(25)
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

        applyCameraInfo(
            lens: metadata?.lens,
            focalLength: metadata?.focalLength,
            aperture: metadata?.aperture,
            iso: metadata?.iso
        )
        
        applyPhotoInfo(
            shutterSpeed: metadata?.shutterSpeed,
            width: metadata?.pixelWidth,
            height: metadata?.pixleHeight,
            fileSize: metadata?.fileSize
        )
        
        applyLocation(
            latitude: metadata?.latitude,
            longitude: metadata?.longitude
        )
    }
}

private extension PhotoMetadataView {
    
    func applyCameraInfo(
        lens: String?,
        focalLength: Double?,
        aperture: Double?,
        iso: Int?
    ) {
        var text = ""
        if let lens { text += "\(lens) - " }
        if let focalLength { text += "\(Int(focalLength.rounded()))mm " }
        if let aperture { text += "𝒇 \(aperture.rounded(toPlaces: 1)) " }
        if let iso { text += "ISO \(iso)" }
        
        firstLabel.text = text
    }
    
    func applyPhotoInfo(
        shutterSpeed: String?,
        width: Int?,
        height: Int?,
        fileSize: Int?
    ) {
        var text = ""
        if let shutterSpeed { text += "\(shutterSpeed) • "}
        if let width, let height { text += "\(width) × \(height) • " }
        if let fileSize {
            let fileSizeFormat = FileSizeFormatter.format(bytes: fileSize, style: .binary)
            text += "\(fileSizeFormat)"
        }
        
        secondLabel.text = text
    }
    
    func applyLocation(latitude: Double?, longitude: Double?) {
  
        guard let latitude, let longitude else {
            emptyLocationContainerView.isHidden = false
            return
        }
        
        emptyLocationContainerView.isHidden = true
        
        // 중심값(필수): 위, 경도
        let center = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )

        // center를 중심으로 지정한 미터(m)만큼의 영역을 보여줌
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
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
