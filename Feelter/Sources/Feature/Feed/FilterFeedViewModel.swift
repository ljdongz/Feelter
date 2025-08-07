//
//  FilterFeedViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import Foundation

import RxSwift

final class FilterFeedViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    @Dependency private var filterRepository: FilterRepository
    
    var disposeBag: DisposeBag = .init()
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
