//
//  DIContainer.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

import FTDependencies
import FTNetwork
import FTNetworkInterface
import FTStorage
import FTStorageInterface
import FTUtility

extension DIContainer {
    func registerDependencies() {
        let appConfiguration = AppConfiguration()
        
        register(appConfiguration, type: EnvironmentProviding.self)
        
        let tokenManager = DefaultTokenManager.shared
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
