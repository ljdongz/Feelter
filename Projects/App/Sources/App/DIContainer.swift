//
//  DIContainer.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
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
        let tokenManager = TokenManager(keychainStorage: keychainStorage)
        let tokenInterceptor = TokenInterceptor(tokenManager: tokenManager)
        let appleAuthService = AppleAuthServiceImpl()
        let kakaoAuthService = KakaoAuthServiceImpl()
        let networkProvider = NetworkProviderImpl(tokenInterceptor: tokenInterceptor)
        let socketProvider = SocketProviderImpl(tokenManager: tokenManager)
        let chatDataSource = ChatDataSourceImpl()
        
        register(tokenManager, type: TokenManager.self)
        register(networkProvider, type: NetworkProvider.self)
        
        let authRepository = AuthRepositoryImpl(
            appleAuthService: appleAuthService,
            kakaoAuthService: kakaoAuthService,
            networkProvider: networkProvider,
            tokenManager: tokenManager
        )
        let userRepository = UserRepositoryImpl(
            networkProvider: networkProvider
        )
        let filterRepository = FilterRepositoryImpl(
            networkProvider: networkProvider
        )
        let bannerRepository = BannerRepositoryImpl(
            networkProvider: networkProvider
        )
        let chatRepository = ChatRepositoryImpl(
            networkProvider: networkProvider,
            socketProvider: socketProvider,
            chatDataSource: chatDataSource
        )
        let orderRepository = OrderRepositoryImpl(
            networkProvider: networkProvider
        )
        let paymentRepository = PaymentRepositoryImpl(
            networkProvider: networkProvider
        )
        
        register(authRepository, type: AuthRepository.self)
        register(userRepository, type: UserRepository.self)
        register(filterRepository, type: FilterRepository.self)
        register(bannerRepository, type: BannerRepository.self)
        register(chatRepository, type: ChatRepository.self)
        register(orderRepository, type: OrderRepository.self)
        register(paymentRepository, type: PaymentRepository.self)
    }
}
