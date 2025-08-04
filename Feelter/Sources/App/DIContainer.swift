//
//  DIContainer.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

final class DIContainer {
    public static let shared = DIContainer()
    private var dependencies: [String: Any] = [:]
    
    private init() {}
    
    func register<T, U>(_ dependency: T, type: U.Type) {
        let key = String(describing: U.self)
        dependencies[key] = dependency
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        let dependency = dependencies[key]
        
        guard let dependency = dependency as? T else {
            fatalError("\(key)는 register되지 않았어어요. resolve 부르기전에 register 해주세요")
        }
        
        return dependency
    }
}

@propertyWrapper
struct Dependency<T> {
    let wrappedValue: T
    
    init() {
        self.wrappedValue = DIContainer.shared.resolve(T.self)
    }
}

extension DIContainer {
    func registerDependencies() {
        let keychainStorage = KeychainStorageImpl()
        let tokenInterceptor = TokenInterceptor(keychainStorage: keychainStorage)
        let appleAuthService = AppleAuthServiceImpl()
        let kakaoAuthService = KakaoAuthServiceImpl()
        let networkProvider = NetworkProviderImpl(tokenInterceptor: tokenInterceptor)
        
        let authRepository = AuthRepositoryImpl(
            appleAuthService: appleAuthService,
            kakaoAuthService: kakaoAuthService,
            networkProvider: networkProvider
        )
        
        register(authRepository, type: AuthRepository.self)
    }
}
