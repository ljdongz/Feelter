//
//  FilterMakeViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/11/25.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

import FTDependencies
import FTUtility

final class FilterMakeViewModel: ViewModel {
    struct Input {
        let titleTextFieldValue: Observable<String>
        let categoryValue: Observable<FilterCategory>
        let descriptionTextFieldValue: Observable<String>
        let priceTextFieldValue: Observable<String>
        let uploadImageValue: Observable<(ImageComparison, FilterAttribute)>
        let createFilterButtonTapped: Observable<Void>
    }
    
    struct Output {
        let isEnableCreateButton = BehaviorRelay<Bool>(value: false)
        let responseSuccess = PublishRelay<Void>()
        let responseError = PublishRelay<String>()
    }
    
    var disposeBag: DisposeBag = .init()
    
    @Dependency private var filterRepository: FilterRepository
    
    private var createFilter = CreateFilter()
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.titleTextFieldValue
            .subscribe(with: self) { owner, title in
                owner.createFilter.title = title
                
                output.isEnableCreateButton.accept(owner.checkIsEnableCreateButton())
            }
            .disposed(by: disposeBag)
        
        input.categoryValue
            .subscribe(with: self) { owner, category in
                owner.createFilter.category = category.rawValue
            }
            .disposed(by: disposeBag)
        
        input.descriptionTextFieldValue
            .subscribe(with: self) { owner, description in
                owner.createFilter.description = description
                
                output.isEnableCreateButton.accept(owner.checkIsEnableCreateButton())
            }
            .disposed(by: disposeBag)
        
        input.priceTextFieldValue
            .compactMap { Int($0) }
            .subscribe(with: self) { owner, price in
                owner.createFilter.price = price
                
                output.isEnableCreateButton.accept(owner.checkIsEnableCreateButton())
            }
            .disposed(by: disposeBag)
        
        input.uploadImageValue
            .subscribe(with: self) { owner, result in
                owner.createFilter.imageComparison = result.0
                owner.createFilter.filterAttribute = result.1
                
                output.isEnableCreateButton.accept(owner.checkIsEnableCreateButton())
            }
            .disposed(by: disposeBag)
        
        input.createFilterButtonTapped
            .compactMap { [weak self] _ -> (Data, Data)? in
                guard let self = self,
                      let originalImage = self.createFilter.imageComparison?.origin,
                      let filteredImage = self.createFilter.imageComparison?.filtered,
                      let originalData = self.compressionImage(image: originalImage),
                      let filteredData = self.compressionImage(image: filteredImage) else {
                    return nil
                }
                
                return (originalData, filteredData)
            }
            .withAsyncResult(with: self) { owner, datas in
                let fileURLs = try await owner.filterRepository.uploadFilterImage(original: datas.0, filtered: datas.1)
                owner.createFilter.fileURLs = fileURLs
                return try await owner.filterRepository.createFilter(filter: owner.createFilter)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    output.responseSuccess.accept(())
                case .failure(let error):
                    print(error)
                    output.responseError.accept("필터 생성에 실패하였습니다.")
                }
            }
            .disposed(by: disposeBag)
            
        return output
    }
}

extension FilterMakeViewModel {
    func checkIsEnableCreateButton() -> Bool {
        !createFilter.title.isEmpty &&
        !createFilter.description.isEmpty &&
        (createFilter.price != -1) &&
        (createFilter.imageComparison != nil)
    }
    
    func compressionImage(image: UIImage) -> Data? {
        let maxSizeInBytes = 1024 * 1024 // 1MB
        let maxWidth: CGFloat = 1320

        // 1) 리사이징 (너비가 maxWidth를 초과하는 경우)
        var targetImage = image
        if image.size.width > maxWidth {
            targetImage = image.resized(toWidth: maxWidth) ?? image
        }

        // 2) jpeg로 압축
        var compressionQuality: CGFloat = 1.0
        var imageData = targetImage.jpegData(compressionQuality: compressionQuality)

        // 3) 이미지 데이터가 1MB보다 작거나 같으면 바로 반환
        if let data = imageData, data.count <= maxSizeInBytes {
            return data
        }

        // 4) 1MB를 초과하는 경우 압축 품질을 0.1씩 줄여가며 압축
        while compressionQuality >= 0.1 {
            compressionQuality -= 0.1
            imageData = targetImage.jpegData(compressionQuality: compressionQuality)

            if let data = imageData, data.count <= maxSizeInBytes {
                return data
            }
        }

        return imageData
    }
}
