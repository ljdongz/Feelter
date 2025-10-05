//
//  PGWebViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/22/25.
//

import Foundation

import RxCocoa
import RxSwift

final class PGWebViewModel: ViewModel {
    struct Input {
        let validPayment: Observable<String>
    }
    
    struct Output {
        let validationResult = PublishRelay<Result<Void, Error>>()
    }
    
    @Dependency private var paymentRepository: PaymentRepository
    
    var disposeBag: DisposeBag = .init()
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.validPayment
            .withAsyncResult(with: self) { owner, impUID in
                try await owner.paymentRepository.validatePayment(impID: impUID)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    output.validationResult.accept(.success(()))
                case .failure(let error):
                    output.validationResult.accept(.failure(error))
                }
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
