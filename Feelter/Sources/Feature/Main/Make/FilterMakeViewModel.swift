//
//  FilterMakeViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/11/25.
//

import Foundation

import RxCocoa
import RxSwift

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
            .subscribe(with: self) { owner, _ in
                print(owner.createFilter)
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
}
