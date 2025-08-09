//
//  FilterDetailViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/9/25.
//

import Foundation

import RxCocoa
import RxSwift

final class FilterDetailViewModel: ViewModel {
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
