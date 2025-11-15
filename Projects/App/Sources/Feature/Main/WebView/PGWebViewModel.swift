//
//  PGWebViewModel.swift
//  Feelter
//
//  Created by 이정동 on 8/22/25.
//

import Foundation

import RxCocoa
import RxSwift

import FTDependencies
import FTUtility

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
            .flatMap { [weak self] impUID -> Observable<Event<Void>> in
                guard let self = self else {
                    return Observable.just(Event.error(NSError(domain: "", code: -1)))
                }
                
                return Observable.create { observer in
                    Task {
                        do {
                            _ = try await self.paymentRepository.validatePayment(impID: impUID)
                            observer.onNext(())
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                    }
                    return Disposables.create()
                }
                .retry(when: { observableError in
                    observableError.enumerated().flatMap { (attempt, error) -> Observable<Int> in
                        guard let urlError = error as? URLError,
                              [.timedOut, .networkConnectionLost].contains(urlError.code),
                              attempt < 2 else {
                            return Observable.error(error)
                        }
                        
                        return Observable<Int>.timer(
                            .seconds(1),
                            scheduler: MainScheduler.instance
                        )
                    }
                })
                .materialize()
            }
            .subscribe(with: self) { owner, event in
                switch event {
                case .next:
                    output.validationResult.accept(.success(()))
                case .error(let error):
                    output.validationResult.accept(.failure(error))
                case .completed:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
