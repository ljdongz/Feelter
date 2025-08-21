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
        let likekButtonTapped: Observable<Void>
        let paymentButtonTapped: Observable<Void>
        let succeedPayment: Observable<Void>
    }
    
    struct Output {
        let filterDetail = PublishRelay<FilterDetail>()
        let updatedLikeStatus = PublishRelay<Bool>()
        let receiveOrderCode = PublishRelay<PaymentInfo>()
    }
    
    @Dependency private var filterRepository: FilterRepository
    @Dependency private var orderRepository: OrderRepository
    
    private let filterID: String
    private(set) var isLiked: Bool
    private var filter: FilterDetail?
    
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
                    owner.filter = filterDetail
                    
                    output.filterDetail.accept(filterDetail)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.likekButtonTapped
            .withAsyncResult(with: self) { owner, _ in
                try await owner.filterRepository.updateLikeStatus(
                    filterID: owner.filterID,
                    isLiked: !owner.isLiked
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    owner.isLiked.toggle()
                    
                    output.updatedLikeStatus.accept(owner.isLiked)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.paymentButtonTapped
            .compactMap { [weak self] in self?.filter }
            .withAsyncResult(with: self) { owner, filter in
                let createOrder = CreateOrder(
                    filterID: owner.filterID,
                    price: filter.price
                )
                return try await owner.orderRepository.createOrder(createOrder)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let orderCode):
                    guard let filter = owner.filter else { return }
                    let paymentInfo = PaymentInfo(
                        orderCode: orderCode,
                        filterName: filter.title,
                        price: filter.price,
                        buyerName: "구매자"
                    )
                    
                    output.receiveOrderCode.accept(paymentInfo)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.succeedPayment
            .compactMap { [weak self] in
                guard let filter = self?.filter else { return nil }
                let newFilter = self?.updateDownloadStatus(from: filter)
                return newFilter
            }
            .subscribe(with: self) { owner, filter in
                output.filterDetail.accept(filter)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

extension FilterDetailViewModel {
    private func updateDownloadStatus(
        from filter: FilterDetail
    ) -> FilterDetail {
        var newFilter = filter
        newFilter.isDownloaded = true
        return newFilter
    }
}
