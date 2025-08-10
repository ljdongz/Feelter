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
        let viewDidLoad: Observable<Void>
        let bookmarkButtonTapped: Observable<Void>
    }
    
    struct Output {
        let filterDetail = PublishRelay<FilterDetail>()
    }
    
    @Dependency private var filterRepository: FilterRepository
    
    private let filterID: String
    private var isLiked: Bool
    
    var disposeBag: DisposeBag = .init()
    
    init(filterID: String, isLiked: Bool) {
        self.filterID = filterID
        self.isLiked = isLiked
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .withAsyncResult(with: self) { owner, _ in
                try await owner.filterRepository.fetchDetailFilter(filterID: owner.filterID)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let filterDetail):
                    output.filterDetail.accept(filterDetail)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        return output
    }
}
