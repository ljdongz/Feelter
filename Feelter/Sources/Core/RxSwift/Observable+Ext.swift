//
//  Observable+Ext.swift
//  Feelter
//
//  Created by Claude on 7/31/25.
//

import Foundation

import RxSwift

// MARK: - Instance Method
extension Observable {
    func withAsyncResult<T, Object: AnyObject>(
        with object: Object,
        _ operation: @escaping (Object, Element) async throws -> T
    ) -> Observable<Result<T, Error>> {
        
        return flatMap { [weak object] element -> Observable<Result<T, Error>> in
            
            guard let object else { return .empty() }
            
            return .create { observer in
                let task = Task {
                    do {
                        let result = try await operation(object, element)
                        observer.onNext(.success(result))
                    } catch {
                        observer.onNext(.failure(error))
                    }
                    observer.onCompleted()
                }
                
                return Disposables.create {
                    task.cancel()
                }
            }
        }
    }
    
    func withAsync<T, Object: AnyObject>(
        with object: Object,
        _ operation: @escaping (Object, Element) async -> T
    ) -> Observable<T> {
        
        return flatMap { [weak object] element -> Observable<T> in
            
            guard let object else { return .empty() }
            
            return .create { observer in
                let task = Task {
                    let result = await operation(object, element)
                    observer.onNext(result)
                    observer.onCompleted()
                }
                
                return Disposables.create {
                    task.cancel()
                }
            }
        }
    }
}

// MARK: - Static Method
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
    
    static func fromAsyncResult<T>(
        operation: @escaping () async throws -> T
    ) -> Observable<Result<T, Error>> {
        return Observable<Result<T, Error>>.create { observer in
            let task = Task {
                do {
                    let result = try await operation()
                    observer.onNext(.success(result))
                } catch {
                    observer.onNext(.failure(error))
                }
                observer.onCompleted()
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
