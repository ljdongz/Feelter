//
//  ChatImageLayoutView.swift
//  Feelter
//
//  Created by 이정동 on 9/6/25.
//

import UIKit

import Kingfisher
import SnapKit

final class ChatImageLayoutView: BaseView {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 2
        view.distribution = .fill
        return view
    }()
    
    private var imageViews: [UIImageView] = []
    private var images: [UIImage] = []
    
    override func setupSubviews() {
        addSubview(stackView)
    }
    
    override func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.lessThanOrEqualTo(220)
        }
    }
    
    func configureImages(_ images: [UIImage]) {
        self.images = images
        clearImageViews()
        createLayout()
    }
    
    func configureImageURLs(_ imageURLs: [String]) {
        // URL로부터 UIImage 배열 생성 (Kingfisher 사용)
        self.images = Array(repeating: UIImage(), count: imageURLs.count) // 임시 배열
        clearImageViews()
        createLayoutWithURLs(imageURLs)
    }
    
    func clearImageViews() {
        imageViews.forEach {
            ImageLoader.shared.cancelDownloadTask(for: $0)
            $0.removeFromSuperview()
        }
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        imageViews.removeAll()
    }
    
    func cancelImageLoading() {
        imageViews.forEach {
            ImageLoader.shared.cancelDownloadTask(for: $0)
        }
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .gray90
        return imageView
    }
}

// MARK: - Configure With UIImage

extension ChatImageLayoutView {
    private func createLayout() {
        switch images.count {
        case 1:
            createSingleImageLayout()
        case 2, 3:
            createHorizontalLayout()
        case 4:
            createGridLayout(rows: 2, columns: 2)
        case 5:
            createCustomGridLayout()
        default:
            break
        }
    }
    
    private func createSingleImageLayout() {
        guard let image = images.first else { return }
        
        let imageView = createImageView()
        imageView.image = image
        
        stackView.addArrangedSubview(imageView)
        imageViews.append(imageView)
        
        // 이미지 비율에 따른 동적 크기 설정
        let aspectRatio = image.size.width / image.size.height
        let maxWidth: CGFloat = 200
        let maxHeight: CGFloat = 300
        
        if aspectRatio > 1 {
            // 가로가 긴 이미지
            let width = min(maxWidth, image.size.width)
            let height = width / aspectRatio
            imageView.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: width, height: min(height, maxHeight)))
            }
        } else {
            // 세로가 긴 이미지 또는 정사각형
            let height = min(maxHeight, image.size.height)
            let width = height * aspectRatio
            imageView.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: min(width, maxWidth), height: height))
            }
        }
    }
    
    private func createHorizontalLayout() {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 2
        horizontalStack.distribution = .fillEqually
        
        for image in images {
            let imageView = createImageView()
            imageView.image = image
            horizontalStack.addArrangedSubview(imageView)
            imageViews.append(imageView)
        }
        
        stackView.addArrangedSubview(horizontalStack)
        
        // 고정 크기 설정
        let itemSize: CGFloat = 80
        horizontalStack.snp.makeConstraints { make in
            make.height.equalTo(itemSize)
        }
    }
    
    private func createGridLayout(rows: Int, columns: Int) {
        let itemSize: CGFloat = 80
        
        for row in 0..<rows {
            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            horizontalStack.spacing = 2
            horizontalStack.distribution = .fillEqually
            
            for col in 0..<columns {
                let imageIndex = row * columns + col
                if imageIndex < images.count {
                    let imageView = createImageView()
                    imageView.image = images[imageIndex]
                    horizontalStack.addArrangedSubview(imageView)
                    imageViews.append(imageView)
                }
            }
            
            stackView.addArrangedSubview(horizontalStack)
            horizontalStack.snp.makeConstraints { make in
                make.height.equalTo(itemSize)
            }
        }
    }
    
    private func createCustomGridLayout() {
        // 5개: 첫 번째 행 3개 (작은 크기), 두 번째 행 2개 (큰 크기)
        let totalWidth: CGFloat = 246  // 전체 너비
        let spacing: CGFloat = 2
        let itemHeight: CGFloat = 80
        
        // 첫 번째 행 (3개)
        let firstRow = UIStackView()
        firstRow.axis = .horizontal
        firstRow.spacing = spacing
        firstRow.distribution = .fillEqually
        
        for i in 0..<3 {
            let imageView = createImageView()
            imageView.image = images[i]
            firstRow.addArrangedSubview(imageView)
            imageViews.append(imageView)
        }
        
        stackView.addArrangedSubview(firstRow)
        firstRow.snp.makeConstraints { make in
            make.height.equalTo(itemHeight)
            make.width.equalTo(totalWidth)
        }
        
        // 두 번째 행 (2개 - 더 넓은 이미지)
        let secondRow = UIStackView()
        secondRow.axis = .horizontal
        secondRow.spacing = spacing
        secondRow.distribution = .fillEqually
        
        for i in 3..<5 {
            let imageView = createImageView()
            imageView.image = images[i]
            secondRow.addArrangedSubview(imageView)
            imageViews.append(imageView)
        }
        
        stackView.addArrangedSubview(secondRow)
        secondRow.snp.makeConstraints { make in
            make.height.equalTo(itemHeight)
            make.width.equalTo(totalWidth)
        }
    }
}

// MARK: - Configure With URL

extension ChatImageLayoutView {
    private func createLayoutWithURLs(_ imageURLs: [String]) {
        switch imageURLs.count {
        case 1:
            createSingleImageLayoutWithURL(imageURLs[0])
        case 2, 3:
            createHorizontalLayoutWithURLs(imageURLs)
        case 4:
            createGridLayoutWithURLs(imageURLs, rows: 2, columns: 2)
        case 5:
            createCustomGridLayoutWithURLs(imageURLs)
        default:
            break
        }
    }
    
    private func createSingleImageLayoutWithURL(_ imageURL: String) {
        let imageView = createImageView()
        setImageWithURL(imageView, imageURL)
        
        stackView.addArrangedSubview(imageView)
        imageViews.append(imageView)
        
        // 기본 크기 설정 (실제 이미지 로드 후 비율 조정)
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 200, height: 200))
        }
    }
    
    private func createHorizontalLayoutWithURLs(_ imageURLs: [String]) {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 2
        horizontalStack.distribution = .fillEqually
        
        for imageURL in imageURLs {
            let imageView = createImageView()
            setImageWithURL(imageView, imageURL)
            horizontalStack.addArrangedSubview(imageView)
            imageViews.append(imageView)
        }
        
        stackView.addArrangedSubview(horizontalStack)
        
        let itemSize: CGFloat = 80
        horizontalStack.snp.makeConstraints { make in
            make.height.equalTo(itemSize)
        }
    }
    
    private func createGridLayoutWithURLs(_ imageURLs: [String], rows: Int, columns: Int) {
        let itemSize: CGFloat = 80
        
        for row in 0..<rows {
            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            horizontalStack.spacing = 2
            horizontalStack.distribution = .fillEqually
            
            for col in 0..<columns {
                let imageIndex = row * columns + col
                if imageIndex < imageURLs.count {
                    let imageView = createImageView()
                    setImageWithURL(imageView, imageURLs[imageIndex])
                    horizontalStack.addArrangedSubview(imageView)
                    imageViews.append(imageView)
                }
            }
            
            stackView.addArrangedSubview(horizontalStack)
            horizontalStack.snp.makeConstraints { make in
                make.height.equalTo(itemSize)
            }
        }
    }
    
    private func createCustomGridLayoutWithURLs(_ imageURLs: [String]) {
        let totalWidth: CGFloat = 246
        let spacing: CGFloat = 2
        let itemHeight: CGFloat = 80
        
        // 첫 번째 행 (3개)
        let firstRow = UIStackView()
        firstRow.axis = .horizontal
        firstRow.spacing = spacing
        firstRow.distribution = .fillEqually
        
        for i in 0..<3 {
            let imageView = createImageView()
            setImageWithURL(imageView, imageURLs[i])
            firstRow.addArrangedSubview(imageView)
            imageViews.append(imageView)
        }
        
        stackView.addArrangedSubview(firstRow)
        firstRow.snp.makeConstraints { make in
            make.height.equalTo(itemHeight)
            make.width.equalTo(totalWidth)
        }
        
        // 두 번째 행 (2개)
        let secondRow = UIStackView()
        secondRow.axis = .horizontal
        secondRow.spacing = spacing
        secondRow.distribution = .fillEqually
        
        for i in 3..<5 {
            let imageView = createImageView()
            setImageWithURL(imageView, imageURLs[i])
            secondRow.addArrangedSubview(imageView)
            imageViews.append(imageView)
        }
        
        stackView.addArrangedSubview(secondRow)
        secondRow.snp.makeConstraints { make in
            make.height.equalTo(itemHeight)
            make.width.equalTo(totalWidth)
        }
    }
    
    private func setImageWithURL(_ imageView: UIImageView, _ urlString: String) {
        // TODO: 다운샘플링 사이즈 설정 수정 (UIImageView 사이즈 그대로 전달 X -> 크기가 설정되지 않은 UIImageView임)
        ImageLoader.shared.applyAuthenticatedImage(
            for: imageView,
            path: urlString,
            cachePolicy: .diskCache(expiration: .chatMessageFile)
        )
    }
}
