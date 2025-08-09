//
//  FilterFeedViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import Foundation

import RxCocoa
import RxSwift

final class FilterFeedViewModel: ViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let categoryButtonTapped: Observable<FilterCategory>
        let orderButtonTapped: Observable<FilterOrder>
    }
    
    struct Output {
        let filters = PublishRelay<[Filter]>()
    }
    
    @Dependency private var filterRepository: FilterRepository
    
    private var nextCursor: String?
    
    var disposeBag: DisposeBag = .init()
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .withAsyncResult(with: self) { owner, _ in
                try await owner.filterRepository.fetchFilters(query: nil)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let filterFeed):
                    owner.nextCursor = filterFeed.nextCursor
                    
                    output.filters.accept(filterFeed.filters)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
