//
//  HomeViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

import RxCocoa
import RxSwift

final class HomeViewModel: ViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        
        let todayFilter = PublishRelay<Filter>()
        let hotTrendFilters = PublishRelay<[Filter]>()
        let todayAuthor = PublishRelay<TodayAuthor>()
    }
    
    @Dependency private var userRepository: UserRepository
    @Dependency private var filterRepository: FilterRepository
    
    var disposeBag: DisposeBag = .init()
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .do(onNext: { _ in
                output.isLoading.accept(true)
            })
            .withAsyncResult(with: self) { owner, _ in
                async let todayAuthor = owner.userRepository.fetchTodayAuthor()
                async let todayFilter = owner.filterRepository.fetchTodayFilter()
                async let hotTrendFilters = owner.filterRepository.fetchHotTrendFilters()
                
                let result = try await (todayFilter, hotTrendFilters, todayAuthor)
                return result
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case let .success((todayFilter, hotTrendFilters, todayAuthor)):
                    output.todayFilter.accept(todayFilter)
                    output.hotTrendFilters.accept(hotTrendFilters)
                    output.todayAuthor.accept(todayAuthor)
                case let .failure(error):
                    print(error)
                    // TODO: 홈 화면에서 재요청 버튼 생성되도록
                }
                
                output.isLoading.accept(false)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}


