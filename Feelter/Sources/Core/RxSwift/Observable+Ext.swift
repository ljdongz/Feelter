//
//  Observable+Ext.swift
//  Feelter
//
//  Created by Claude on 7/31/25.
//

import Foundation

import RxSwift

extension Observable {
    
    /// async 함수를 Observable로 변환
    /// - Parameter operation: 실행할 async 함수
    /// - Returns: async 함수의 결과를 방출하는 Observable
    static func fromAsync<T>(
        operation: @escaping () async throws -> T
    ) -> Observable<T> {
        return Observable<T>.create { observer in
            let task = Task {
                do {
                    let result = try await operation()
                    observer.onNext(result)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    /// async 함수를 Observable로 변환
    /// - Parameter operation: 실행할 async 함수
    /// - Returns: async 함수의 결과를 방출하는 Observable
    static func fromAsync<T>(
        operation: @escaping () async -> T
    ) -> Observable<T> {
        return Observable<T>.create { observer in
            let task = Task {
                let result = await operation()
                observer.onNext(result)
                observer.onCompleted()
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
