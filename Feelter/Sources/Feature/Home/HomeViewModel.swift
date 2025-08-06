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
        
        let homeModel = PublishRelay<HomeModel>()
//        let todayFilter = PublishRelay<Filter>()
//        let banners = PublishRelay<[Banner]>()
//        let hotTrendFilters = PublishRelay<[Filter]>()
//        let todayAuthor = PublishRelay<TodayAuthor>()
    }
    
    @Dependency private var userRepository: UserRepository
    @Dependency private var filterRepository: FilterRepository
    @Dependency private var bannerRepository: BannerRepository
    
    var disposeBag: DisposeBag = .init()
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .do(onNext: { _ in
                output.isLoading.accept(true)
            })
            .withAsyncResult(with: self) { owner, _ in
                async let todayFilter = owner.filterRepository.fetchTodayFilter()
                async let banners = owner.bannerRepository.fetchBanners()
                async let hotTrendFilters = owner.filterRepository.fetchHotTrendFilters()
                async let todayAuthor = owner.userRepository.fetchTodayAuthor()
                
                let result = try await (todayFilter, banners, hotTrendFilters, todayAuthor)
                return HomeModel(
                    todayFilter: result.0,
                    banners: result.1,
                    hotTrendFilters: result.2,
                    todayAuthor: result.3
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case let .success(data):
                    output.homeModel.accept(data)
//                    output.todayFilter.accept(todayFilter)
//                    output.banners.accept(banners)
//                    output.hotTrendFilters.accept(hotTrendFilters)
//                    output.todayAuthor.accept(todayAuthor)
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

extension HomeViewModel {
    struct HomeModel {
        let todayFilter: Filter
        let banners: [Banner]
        let hotTrendFilters: [Filter]
        let todayAuthor: TodayAuthor
    }
}
