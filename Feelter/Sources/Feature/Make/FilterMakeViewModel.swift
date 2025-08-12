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
        
    }
    
    struct Output {
        
    }
    
    var disposeBag: DisposeBag = .init()
    
    @Dependency private var filterRepository: FilterRepository
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
