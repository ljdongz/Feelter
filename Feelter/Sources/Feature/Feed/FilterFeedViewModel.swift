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
        let updatedLikeStatus: Observable<Filter>
    }
    
    struct Output {
        let filters = PublishRelay<[Filter]>()
    }
    
    @Dependency private var filterRepository: FilterRepository
    
    private var currentQuery = FilterQuery(
        nextID: nil,
        limit: 10,
        category: nil,
        order: .latest
    )
    
    private(set) var filters: [Filter] = []
    
    var disposeBag: DisposeBag = .init()
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .withAsyncResult(with: self) { owner, _ in
                try await owner.filterRepository.fetchFilters(query: owner.currentQuery)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let filterFeed):
                    owner.currentQuery.nextID = filterFeed.nextCursor
                    owner.filters = filterFeed.filters
                    
                    output.filters.accept(filterFeed.filters)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.categoryButtonTapped
            .do { [weak self] category in
                let currentCatetory = self?.currentQuery.category
                self?.currentQuery.category = currentCatetory == category ? nil : category
                self?.currentQuery.nextID = nil
            }
            .compactMap { [weak self] _ in self?.currentQuery }
            .withAsyncResult(with: self) { owner, query in
                try await owner.filterRepository.fetchFilters(query: query)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let filterFeed):
                    owner.currentQuery.nextID = filterFeed.nextCursor
                    owner.filters = filterFeed.filters
                    
                    output.filters.accept(filterFeed.filters)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.orderButtonTapped
            .distinctUntilChanged()
            .do(onNext: { [weak self] order in
                self?.currentQuery.order = order
                self?.currentQuery.nextID = nil
            })
            .compactMap { [weak self] _ in self?.currentQuery }
            .withAsyncResult(with: self) { owner, query in
                try await owner.filterRepository.fetchFilters(query: query)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let filterFeed):
                    owner.currentQuery.nextID = filterFeed.nextCursor
                    owner.filters = filterFeed.filters
                    
                    output.filters.accept(filterFeed.filters)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.updatedLikeStatus
            .subscribe(with: self) { owner, filter in
                guard let index = owner.filters.firstIndex(of: filter) else {
                    return
                }
                owner.filters[index].isLiked?.toggle()
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
